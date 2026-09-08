# TEMASIS

Aplicación web PHP con arquitectura MVC propia y SQL Server. Los controllers, models y vistas residen en la aplicación web; gran parte de las reglas de negocio, consultas y validaciones se implementa en stored procedures.

## Estructura real

```text
TEMASIS/
|-- customers/                           # Aplicación web desplegable
|   |-- wwwroot/                         # Document root y puntos de entrada
|   |-- system/
|   |   |-- config/                      # Configuración de la aplicación
|   |   `-- engine/                      # Framework PHP utilizado en runtime
|   `-- tmssOnLine/
|       |-- controller/                  # Controllers PHP
|       |-- model/                       # Models PHP
|       |-- view/default/                # Vistas PHP/HTML (.frm)
|       `-- language/                    # Textos e idioma
|-- engine/                              # Copia de soporte del motor
`-- batabase/                            # Scripts SQL Server
    |-- core/                            # Base central del sistema
    |   |-- tmmsStored/                  # Stored procedures
    |   |-- tmssFunctions/               # Funciones compartidas
    |   `-- tmssTables/                  # Definiciones de tablas
    `-- customers/                       # Base de cada cliente
        |-- tmmsStored/                  # Stored procedures
        |-- tmssFunctions/               # Funciones compartidas
        `-- tmssTables/                  # Definiciones de tablas
```

El código cargado por la aplicación es `customers/system/engine/`, no `engine/`. Ambos árboles contienen el motor; `engine/` además conserva `tmssDatabaseCfg.example.php`, la plantilla de conexión.

## Requisitos

- PHP 8.1 o superior; `customers/wwwroot/index.php` lo valida al iniciar.
- SQL Server accesible desde PHP.
- Extensión PHP `sqlsrv` habilitada.
- Un servidor web cuyo document root sea `TEMASIS/customers/wwwroot`.

No hay un manifiesto único de Composer o npm en la raíz: las bibliotecas de frontend y PHP ya están incluidas bajo `customers/wwwroot/library/`.

## Configuración local

1. Copiar `engine/tmssDatabaseCfg.example.php` a `customers/system/engine/tmssDatabaseCfg.php`.
2. Completar servidor, base, usuario y contraseña del core de SQL Server.
3. Mantener ese archivo fuera de Git: está excluido por `.gitignore` porque contiene secretos.
4. Configurar el virtual host para servir `customers/wwwroot/`.

La configuración general se carga desde `customers/system/config/tmssOnLine.php`. Los logs se escriben en `customers/system/logs/`; ese directorio no está versionado, por lo que debe crearse en cada despliegue y ser escribible por el usuario del servidor web.

## Conexiones de base de datos

El sistema trabaja con un core y una base por cliente. `tmssDatabaseCfg.php` abre el core en el índice de conexión `0`; no debe apuntar a una base de cliente.

Al atender una operación de cliente, `tmssDatabase` toma el identificador `bsecnx`, consulta `SYS_CNX_DEF` en el core y obtiene la fila activa correspondiente de `SYS_CNX`. Los campos `SysCnxSrv`, `SysCnxDb`, `SysCnxUsr` y `SysCnxPwd` de esa fila abren la conexión del cliente, normalmente en el índice `1`. Las llamadas a base de datos sin índice explícito usan el cliente; las que usan `0` permanecen en el core.

```text
tmssDatabaseCfg.php → core (0) → SYS_CNX_DEF / SYS_CNX → cliente (1)
```

La configuración `customers` de `system/config/tmssOnLine.php` vincula cada acceso con su `connection` (`bsecnx`). Ese valor debe coincidir con `SysCnxCodExt` de una fila activa en `SYS_CNX`.

## Despliegue con Docker

Desde la raíz del repositorio hay perfiles Nginx + PHP-FPM para Alpine y Debian
en [`../docker/`](../docker/README.md). Antes de construir cualquiera de ellos,
la configuración de SQL Server debe existir en
`customers/system/engine/tmssDatabaseCfg.php`, que es la ubicación estándar que
carga la aplicación. El Dockerfile incorpora `customers/` tal como está; Compose
no monta ni genera ese archivo.

```sh
docker compose -f docker/debian/docker-compose.yml up -d --build
```

Ejecutar el comando desde la raíz del repositorio. Para Alpine, reemplazar
`debian` por `alpine`. Consultar [`../docker/README.md`](../docker/README.md)
para variables, actualización, logs y detención.

## Puntos de entrada

- `customers/wwwroot/index.php`: entrada web principal (versión declarada: `2.0.0`). Inicializa configuración, registro de servicios, sesión, request, response, base de datos, seguridad, idioma y documento.
- `customers/wwwroot/indexcmd.php`: entrada alternativa para flujos orientados a comandos/parámetros.

La aplicación elige el programa con `prg`, la acción con `act` y entrega parámetros de negocio que comienzan con `prm_` al controller.

```text
index.php?prg=admbus&act=08&prm_buscod=...
```

## Flujo de una solicitud

1. `index.php` construye un `tmssRegistry` y registra los servicios compartidos.
2. `tmssLoader` resuelve el controller en `customers/tmssOnLine/controller/`.
3. El controller procesa `act`, valida la sesión y carga el model que necesita.
4. El model ejecuta consultas o stored procedures con `tmssDatabase` y `sqlsrv`, en el core o en la base del cliente según el índice de conexión.
5. El controller devuelve una vista `.frm`, una grilla o una respuesta para AJAX.

Si no se recibe `prg`, el punto de entrada comprueba el login, construye el menú y renderiza el layout principal.

## Framework y convenciones

El autoload carga clases cuyo nombre comienza por `tmss` desde `customers/system/engine/`; el resto se busca como controller, en minúsculas. Componentes frecuentes:

- `tmssRegistry`: contenedor de servicios.
- `tmssLoader`: carga controllers, models y vistas.
- `tmssRequest` y `tmssResponse`: entrada y salida HTTP.
- `tmssDatabase`: conexión y ejecución contra SQL Server con `sqlsrv`.
- `tmssSecurity` y `tmssSession`: identidad, empresa activa y permisos.
- `tmssDocument`, `tmssInput` y `tmssLanguage`: presentación, formularios e idioma.

Las vistas tienen extensión `.frm`, pero contienen PHP y HTML. Normalmente reciben servicios y datos a través de variables como `$vew_lang`, `$vew_input`, `$vew_sec`, `$vew_doc`, `$vew_load`, `$vew_db` y `$vew_data`.

La convención histórica de nombres usa prefijos: `$lp_` para parámetros, `$lv_` para variables locales, `$lo_` para objetos/resultados y `$co_` para propiedades de clase. Los nombres de campos de negocio conservan habitualmente el nombre de la columna SQL, como `buscod`, `bustxt` o `usrcod`.

## Ejemplo: empresas

El módulo `admbus` permite seguir la relación completa entre capas:

```text
customers/tmssOnLine/controller/admbus.php
  -> customers/tmssOnLine/model/admbus.php
     -> batabase/customers/tmmsStored/dbo.ADM_BUS_DEF.StoredProcedure.sql
        -> batabase/customers/tmssTables/dbo.ADM_BUS.Table.sql
```

Las acciones más habituales son `01` (alta), `02` (modificación), `03` (consulta), `04` (baja) y `08` (listado). No todos los controllers implementan exactamente el mismo conjunto: revisar el controller y su stored procedure antes de reutilizar una acción.

## Base de datos

- `batabase/core/` contiene el esquema y las reglas de la base central; sus scripts actuales usan `tmssSysPrd`.
- `batabase/customers/` contiene el esquema y reglas que se instalan en cada base de cliente; sus scripts actuales usan `tmssTeam2`.
- Cada grupo se organiza en `tmmsStored/`, `tmssFunctions/` y `tmssTables/`.

Los scripts crean objetos pero todavía no incluyen datos iniciales. En particular, la tabla central `SYS_CNX` debe contar con una fila activa por cliente para que el sistema pueda resolver su conexión.

Para instalar un grupo, crear primero la base que figura en sus sentencias `USE` y aplicar tablas, funciones y procedimientos. En `core/tmssFunctions/`, ejecutar solo los ocho archivos `*.UserDefinedFunction.sql`: los demás son copias de los procedimientos ya presentes en `core/tmmsStored/`.

Los scripts SQL pueden tener codificación UTF-16 LE. Preservar su codificación al editarlos para evitar diffs masivos o archivos que SQL Server no pueda interpretar.

## Lectura inicial recomendada

```text
customers/wwwroot/index.php
customers/system/engine/tmssLoader.php
customers/system/engine/tmssDatabase.php
customers/system/engine/tmssSecurity.php
customers/tmssOnLine/controller/admbus.php
customers/tmssOnLine/model/admbus.php
customers/tmssOnLine/view/default/admbus.frm
batabase/customers/tmmsStored/dbo.ADM_BUS_DEF.StoredProcedure.sql
```
