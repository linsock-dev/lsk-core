# Guía de desarrollo

Esta guía describe cómo extender y revisar LSK Core / TEMASIS. Debe leerse junto con el [README](README.md), que contiene la arquitectura y el inventario general del repositorio.

La base de datos no está disponible en este entorno. Para entender o modificar lógica de datos, usar los scripts de `src/batabase/` como fuente de verdad.

## Preparación local

Se requiere PHP 8.1+, la extensión `sqlsrv`, acceso a SQL Server y un servidor web con document root en `src/customers/wwwroot/`.

1. Crear `src/customers/system/logs/` con permisos de escritura para el servidor web.
2. Copiar `src/engine/tmssDatabaseCfg.example.php` a `src/customers/system/engine/tmssDatabaseCfg.php`.
3. Completar las credenciales locales de SQL Server.
4. Verificar que `tmssDatabaseCfg.php`, tokens, certificados y otros secretos no se incorporen a Git.
5. No usar valores de configuración de clientes existentes para crear secretos nuevos.

No hay un manifiesto raíz de Composer o npm, ni un comando de build del proyecto. Las dependencias se sirven desde `src/customers/wwwroot/library/`.

## Cómo analizar un flujo

Seguir siempre esta cadena antes de modificar una funcionalidad:

```text
Vista / enlace (prg, act, prm_*)
  → Controller
    → Model
      → Stored procedure
        → Tabla(s) y función(es) SQL
```

1. Identificar `prg` y `act` en la vista, enlace o llamada AJAX.
2. Abrir el controlador en `src/customers/tmssOnLine/controller/`.
3. Identificar el modelo cargado por el controlador.
4. Revisar el procedimiento llamado desde el modelo en `src/batabase/tmmsStored/`.
5. Revisar sus tablas en `src/batabase/tmssTables/` y sus funciones dependientes en `src/batabase/tmssFunctions/`.
6. Volver a la vista `.frm` para validar los parámetros, la respuesta y el comportamiento de JavaScript.

No inferir operaciones, parámetros o permisos por el nombre de un procedimiento: están definidos en su script SQL.

## Convenciones de nombres

### Archivos y capas

| Capa | Convención | Ejemplo |
| --- | --- | --- |
| Controlador | minúsculas; prefijo de módulo y entidad | `admbus.php` |
| Modelo | mismo nombre que el controlador asociado | `admbus.php` |
| Vista | mismo nombre funcional, extensión `.frm` | `admbus.frm` |
| Tabla SQL | mayúsculas y `_`, esquema `dbo` | `dbo.ADM_BUS.Table.sql` |
| Stored procedure | tabla/entidad más sufijo `_DEF` | `dbo.ADM_BUS_DEF.StoredProcedure.sql` |
| Función SQL | `dbo.<Nombre>.UserDefinedFunction.sql` | `dbo.CheckAuthorization.UserDefinedFunction.sql` |

Las clases del motor comienzan con `tmss` y se cargan desde `src/customers/system/engine/`. Controllers y modelos se resuelven dinámicamente, por lo que el nombre de archivo, clase y llamada del loader deben permanecer alineados.

### Variables PHP

El código usa una convención histórica por prefijos. Mantenerla en código nuevo y conservar el estilo del archivo que se modifica.

| Prefijo | Uso | Ejemplo |
| --- | --- | --- |
| `$lp_` | parámetro de función o método | `$lp_act`, `$lp_prm` |
| `$lv_` | variable local escalar, arreglo temporal o valor derivado | `$lv_key`, `$lv_buffer` |
| `$lo_` | objeto, modelo, resultado o colección | `$lo_mdl`, `$lo_rs` |
| `$co_` | propiedad interna de una clase | `$co_reg`, `$co_cnx` |
| `$vew_` | variables inyectadas en una vista por `tmssLoader::view` | `$vew_data`, `$vew_lang` |

Reglas complementarias:

- Conservar el nombre de la columna SQL para los campos de negocio: `buscod`, `bustxt`, `usrcod`.
- Usar constantes de clase en mayúsculas cuando el archivo ya emplee ese patrón, por ejemplo `MODEL`, `VIEW`, `ID` y `OBJTYP`.
- Mantener el estilo local de métodos. El proyecto mezcla convenciones históricas como `getList` y `call_sp`; no convertir archivos enteros durante un cambio funcional pequeño.
- Evitar nombres genéricos fuera de un alcance reducido. Preferir `$lv_buscod`, `$lo_usrmdl` o `$lv_sqlprm` cuando expresen el dato o el rol.

## Crear o extender un módulo CRUD

Usar `ADM_BUS` como referencia y mantener todas las capas coherentes:

1. Crear o modificar la tabla en `src/batabase/tmssTables/`.
2. Crear o modificar el procedimiento `dbo.<ENTIDAD>_DEF.StoredProcedure.sql` en `src/batabase/tmmsStored/`.
3. Implementar o adaptar el modelo PHP para preparar parámetros y llamar al procedimiento.
4. Implementar el controlador que valide sesión, procese `act` y entregue una vista o JSON.
5. Crear o adaptar la vista dentro de `src/customers/tmssOnLine/view/default/`.
6. Agregar textos a `src/customers/tmssOnLine/language/tmssLanguage_es.php` y configurar menú/permisos cuando corresponda.
7. Verificar autorización, restricciones por empresa y errores en la capa SQL.

Los modelos habituales exponen `create`, `save`, `load` y `getList`. `call_sp` suele traducir la acción a `@lp_sysoperation`, preparar parámetros y procesar `errtyp`, `errcod`, `errmsg` y `errtxt`.

### Ejemplo mínimo: entidad `ADM_FOO`

El siguiente ejemplo es una plantilla de referencia para una entidad simple. Supone que existe la tabla `ADM_FOO` con las columnas `buscod`, `foocod`, `footxt`, `docsts`, `cteusr`, `ctedte`, `updusr` y `upddte`. Adaptar los tipos, campos, índices, permisos y reglas de negocio antes de usarlo.

#### 1. Stored procedure

Crear `src/batabase/tmmsStored/dbo.ADM_FOO_DEF.StoredProcedure.sql` y conservar UTF-16 LE. El procedimiento recibe la operación, el usuario y la empresa; valida autorización antes de operar.

```sql
CREATE PROCEDURE [dbo].[ADM_FOO_DEF]
  @lp_sysoperation nvarchar(2),
  @lp_username     nvarchar(20),
  @lp_buscod       nvarchar(20),
  @lp_foocod       nvarchar(20) = null,
  @lp_footxt       nvarchar(100) = null,
  @lp_docsts       nvarchar(1) = null
AS
BEGIN
  SET NOCOUNT ON;

  IF @lp_sysoperation IN ('01', '02', '03', '08')
     AND dbo.CheckAuthorization(@lp_username, @lp_buscod, 'ADM', 'FOO',
         CASE WHEN @lp_sysoperation = '08' THEN '**' ELSE @lp_sysoperation END) = 0
  BEGIN
    SELECT 'E' AS errtyp, -9 AS errcod,
           'InvalidAuthorization' AS errmsg,
           'ADM' + CHAR(9) + 'FOO' + CHAR(9) + @lp_sysoperation AS errvar;
    RETURN;
  END;

  IF @lp_sysoperation = '01'
  BEGIN
    INSERT INTO ADM_FOO (buscod, foocod, footxt, docsts, cteusr, ctedte, updusr, upddte)
    VALUES (@lp_buscod, @lp_foocod, @lp_footxt, @lp_docsts,
            @lp_username, GETDATE(), @lp_username, GETDATE());

    SELECT 'S' AS errtyp, 0 AS errcod, @lp_foocod AS foocod, '' AS errtxt;
    RETURN;
  END;

  IF @lp_sysoperation = '02'
  BEGIN
    UPDATE ADM_FOO
       SET footxt = @lp_footxt,
           docsts = @lp_docsts,
           updusr = @lp_username,
           upddte = GETDATE()
     WHERE buscod = @lp_buscod
       AND foocod = @lp_foocod;

    SELECT 'S' AS errtyp, 0 AS errcod, @lp_foocod AS foocod, '' AS errtxt;
    RETURN;
  END;

  IF @lp_sysoperation = '03'
  BEGIN
    SELECT f.*, 'S' AS errtyp, 0 AS errcod, '' AS errtxt
      FROM ADM_FOO f
     WHERE f.buscod = @lp_buscod
       AND f.foocod = @lp_foocod;
    RETURN;
  END;

  IF @lp_sysoperation = '08'
  BEGIN
    SELECT f.*, 'S' AS errtyp, 0 AS errcod, '' AS errtxt
      FROM ADM_FOO f
     WHERE f.buscod = @lp_buscod;
    RETURN;
  END;

  RAISERROR('Operación no válida: %s', 16, 1, @lp_sysoperation);
END
```

#### 2. Modelo

Crear `src/customers/tmssOnLine/model/admfoo.php`. El modelo centraliza el contrato entre PHP y el procedimiento; no debe interpolar valores dentro de SQL.

```php
<?php
final class admfoo extends tmssAction {
  const ID = 'foocod';
  const OBJTYP = 'ADM_FOO';

  protected $co_reg;
  private $data = array();

  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
  function __get($lp_key) { return $this->data[$lp_key] ?? ''; }
  function getData() { return $this->data; }

  function create() { $this->data = array('docsts' => 'A'); }

  function load($lp_key = array()) {
    return $this->call_sp('03', $lp_key, $this->data);
  }

  function save($lp_dat = array()) {
    if (count($lp_dat) == 0) { $lp_dat = $this->co_reg->request->post; }
    $lv_act = empty($lp_dat[self::ID]) ? '01' : '02';
    $lo_out = array();
    return $this->call_sp($lv_act, $lp_dat, $lo_out);
  }

  private function call_sp($lp_act, $lp_in, &$lp_out) {
    $lv_prm = array(
      $lp_act,
      $this->co_reg->sec->usrcod,
      $this->co_reg->sec->buscod,
      $this->co_reg->db->sqldat($lp_in, 'foocod'),
      $this->co_reg->db->sqldat($lp_in, 'footxt'),
      $this->co_reg->db->sqldat($lp_in, 'docsts')
    );

    $lo_rs = $this->co_reg->db->sqlstoredprocedure(
      'ADM_FOO_DEF (?, ?, ?, ?, ?, ?)', $lv_prm
    );

    $this->errcod = intval($lo_rs[0]['errcod'] ?? -9999);
    $this->errtyp = $lo_rs[0]['errtyp'] ?? ($this->errcod == 0 ? 'S' : 'E');
    $this->errtxt = $lo_rs[0]['errtxt'] ?? '';

    if ($this->errcod == 0 && count($lo_rs) > 0) {
      $lp_out = $lo_rs[0];
      $this->data = $lp_out;
      return true;
    }
    return false;
  }
}
?>
```

#### 3. Controlador

Crear `src/customers/tmssOnLine/controller/admfoo.php`. La primera responsabilidad es validar la sesión; la autorización detallada se conserva en el procedimiento.

```php
<?php
final class admfooController extends tmssController {
  const MODEL = 'admfoo';
  const VIEW = 'admfoo';
  const ID = 'foocod';

  protected $co_reg;
  private $lo_mdl;

  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }

  public function index($lp_act, $lp_prm = array()) {
    $this->co_reg->request->post['ajax'] = '1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ($lv_lgnbuf != '') { return $lv_lgnbuf; }

    $this->lo_mdl = $this->co_reg->load->model(self::MODEL);

    switch ('#' . $lp_act) {
      case '#01':
        $this->lo_mdl->create();
        return $this->co_reg->document->getView(self::VIEW,
          array('data' => $this->lo_mdl, 'actcod' => '01'));

      case '#00':
        if ($this->lo_mdl->save()) {
          return $this->co_reg->document->getJson(
            array('errtyp' => 'S', 'errcod' => 0, 'data' => $this->lo_mdl->getData())
          );
        }
        return $this->co_reg->document->getJson(
          array('errtyp' => 'E', 'errcod' => $this->lo_mdl->errcod, 'errtxt' => $this->lo_mdl->errtxt)
        );

      case '#03':
        $lv_key = array(self::ID => $lp_prm[self::ID] ?? '');
        if (!$this->lo_mdl->load($lv_key)) {
          return $this->co_reg->document->getJson(
            array('errtyp' => 'E', 'errcod' => $this->lo_mdl->errcod, 'errtxt' => $this->lo_mdl->errtxt)
          );
        }
        return $this->co_reg->document->getView(self::VIEW,
          array('data' => $this->lo_mdl, 'actcod' => '03'));
    }
  }
}
?>
```

#### 4. Vista

Crear `src/customers/tmssOnLine/view/default/admfoo.frm`. Las vistas son PHP/HTML, reciben `data` como `$vew_data` y deben enviar los mismos nombres de campo que el modelo y el procedimiento esperan.

```php
<section id="admfoo-form">
  <label for="foocod">Código</label>
  <input id="foocod" name="foocod" value="<?= htmlspecialchars($vew_data->foocod); ?>">

  <label for="footxt">Descripción</label>
  <input id="footxt" name="footxt" value="<?= htmlspecialchars($vew_data->footxt); ?>">

  <input type="hidden" id="docsts" name="docsts" value="<?= htmlspecialchars($vew_data->docsts); ?>">
  <button type="button" id="btn-save">Guardar</button>
</section>

<script>
$('#admfoo-form #btn-save').on('click', function () {
  const lv_pstdat = [
    {name: 'foocod', value: $('#admfoo-form #foocod').val()},
    {name: 'footxt', value: $('#admfoo-form #footxt').val()},
    {name: 'docsts', value: $('#admfoo-form #docsts').val()}
  ];

  tmssCallProcess('?prg=admfoo&act=00', lv_pstdat, function (lo_ret) {
    if (lo_ret.errtyp === 'S') {
      toastr.success('Registro guardado');
    } else {
      toastr.error(lo_ret.errtxt || 'No fue posible guardar el registro');
    }
  });
});
</script>
```

Antes de integrar el ejemplo, agregar la tabla, el permiso `ADM/FOO`, los textos de idioma y la entrada de menú que correspondan. Verificar también que el helper de formularios y el formato de respuesta del módulo destino sean compatibles; los módulos existentes pueden requerir convenciones adicionales.

### Acciones SQL frecuentes

| Código | Uso habitual |
| --- | --- |
| `01` | alta |
| `02` | modificación |
| `03` | consulta individual |
| `04` | baja |
| `08` | listado |
| `11`, `12`, `13`, `14`, `18` | variantes internas; revisar el procedimiento específico antes de usarlas |

## Cambios de base de datos

Los scripts SQL están mayormente en **UTF-16 LE**. Preservar su codificación y sus finales de línea al editarlos.

Antes de modificar un script:

1. Identificar las tablas, funciones y procedimientos que dependen del cambio.
2. Revisar `dbo.CheckAuthorization`, `dbo.GetUserRestrictions` y el filtrado por empresa que aplique al caso.
3. Mantener el contrato de parámetros y la forma de respuesta que espera el modelo PHP.
4. Incluir en el mismo cambio todos los scripts afectados.
5. Probar en una base no productiva, con una cuenta de permisos mínimos.

No existe un runner de migraciones. Al preparar una instalación manual, revisar el contenido de cada script y aplicar normalmente en este orden:

```text
tablas → funciones → stored procedures
```

Cada script puede contener `USE`, `CREATE` y dependencias específicas; el orden anterior no sustituye esa revisión.

## Reglas de seguridad

- Validar sesión en los controladores y conservar la autorización en SQL Server.
- Preferir procedimientos almacenados y parámetros de `sqlsrv`; no agregar SQL construido con entradas HTTP.
- No agregar `eval()` a vistas o respuestas AJAX.
- No confiar en headers como identidad sin autenticación verificable.
- No exponer mensajes de error con rutas, consultas, secretos o detalles de infraestructura.
- Excluir credenciales, tokens y datos personales de logs de APIs.
- Revisar con especial atención módulos administrativos capaces de ejecutar SQL o escribir archivos.
- Restringir en el servidor web la ejecución de ejemplos y scripts PHP de terceros bajo `wwwroot/library/`.

## Validación

El repositorio no incluye pruebas automatizadas, CI, contenedor ni build propio. La validación mínima de cada cambio debe incluir:

1. Revisar cambios de formato y espacios:

   ```sh
   git diff --check
   ```

2. Ejecutar lint de PHP cuando el runtime esté instalado:

   ```sh
   rg --files -0 src/customers/tmssOnLine src/customers/system src/customers/wwwroot -g '*.php' \
     | tr '\0' '\n' \
     | rg -v '/library/' \
     | xargs -n 1 php -l
   ```

3. Revisar los SQL modificados sin alterar UTF-16 LE.
4. Probar en SQL Server de desarrollo: login, permisos, flujo afectado y validaciones de error.
5. Probar los listados, respuestas AJAX y sesión del módulo afectado.

Antes de desplegar, confirmar document root, permisos de logs y configuración local de conexión del ambiente de destino.

## Convención de commits

Usar mensajes en español, concisos y descriptivos, con el formato:

```text
tipo(alcance): resumen en imperativo
```

- El resumen debe explicar el cambio, no el archivo editado; usar minúscula inicial y no cerrar con punto.
- Mantener la primera línea en un máximo de 72 caracteres.
- El alcance es opcional, pero recomendable cuando identifica un módulo o capa: `stk`, `sys`, `database`, `auth`, `api`, `docs`.
- Agregar cuerpo cuando explique una decisión, impacto en SQL, compatibilidad, pasos de despliegue o validación realizada.
- Para cambios incompatibles, agregar `BREAKING CHANGE:` en el pie del commit.

Tipos permitidos:

| Tipo | Cuándo usarlo |
| --- | --- |
| `feat` | funcionalidad nueva |
| `fix` | corrección de un defecto |
| `refactor` | reorganización sin cambio funcional previsto |
| `docs` | documentación |
| `test` | pruebas o cobertura |
| `chore` | mantenimiento, herramientas o configuración |
| `security` | corrección o endurecimiento de seguridad |

Ejemplos:

```text
feat(stk): registrar identificación de material
fix(auth): validar vencimiento de token de sesión
refactor(database): reorganizar scripts sql en batabase
docs: documentar flujo de desarrollo y validación
security(api): excluir tokens de los registros de solicitudes
```

Cuando un cambio incluya SQL, el cuerpo debe indicar las tablas, funciones o procedimientos afectados y cómo se validó en un ambiente no productivo.
