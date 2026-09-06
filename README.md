# LSK Core / TEMASIS

Aplicación web empresarial multiempresa desarrollada en PHP, con un MVC propio y SQL Server. La capa PHP entrega la interfaz y orquesta los casos de uso; el esquema, las reglas de negocio, las restricciones y la mayor parte de las consultas viven en scripts SQL versionados dentro del repositorio.

> Este proyecto no incluye una base de datos ejecutable ni una configuración local de conexión. Por lo tanto, el análisis y el desarrollo de la capa de datos deben basarse en los scripts de `src/batabase/`.

## Índice

- [Arquitectura](#arquitectura)
- [Estructura del repositorio](#estructura-del-repositorio)
- [Módulos funcionales](#módulos-funcionales)
- [Base de datos](#base-de-datos)
- [Requisitos y configuración local](#requisitos-y-configuración-local)
- [Puntos de entrada](#puntos-de-entrada)
- [Guía de desarrollo](DEVELOPMENT.md)
- [Validación y despliegue](#validación-y-despliegue)
- [Consideraciones de seguridad y mantenimiento](#consideraciones-de-seguridad-y-mantenimiento)

## Arquitectura

El recorrido habitual de una solicitud web es el siguiente:

```text
Navegador
  → wwwroot/index.php
    → tmssRegistry (servicios compartidos)
      → tmssLoader (despacho dinámico)
        → Controller
          → Model
            → Stored procedure SQL Server
              → Tabla(s), función(es) y autorización
        → Vista .frm / JSON / AJAX
```

La URL determina el programa y la acción:

```text
index.php?prg=admbus&act=08&prm_buscod=...
```

- `prg`: controlador a ejecutar.
- `act`: operación del caso de uso.
- `prm_*`: parámetros de negocio que llegan al controlador sin el prefijo `prm_`.

El arranque registra configuración, logging, sesión, request, response, base de datos, seguridad, idioma y documento. Si no se informa `prg`, genera el menú y el layout de la sesión autenticada.

## Estructura del repositorio

```text
.
├── README.md
└── src/
    ├── customers/                       # Aplicación desplegable
    │   ├── wwwroot/                     # Document root y puntos de entrada
    │   ├── system/
    │   │   ├── config/                  # Configuración de la aplicación
    │   │   └── engine/                  # Motor PHP usado en runtime
    │   └── tmssOnLine/
    │       ├── controller/              # 301 controladores
    │       ├── model/                   # 359 modelos
    │       ├── view/default/            # 555 vistas PHP/HTML (.frm)
    │       └── language/                # Textos e idioma
    ├── engine/                          # Copia del motor y plantilla de conexión
    └── batabase/                        # Fuente de verdad de la capa SQL
        ├── tmssTables/                  # 425 definiciones de tablas
        ├── tmssFunctions/               # 19 funciones compartidas
        └── tmmsStored/                  # 375 stored procedures
```

`src/customers/system/engine/` es la copia del motor que carga la aplicación. `src/engine/` se conserva como soporte y contiene `tmssDatabaseCfg.example.php`, la plantilla de configuración de SQL Server.

Las dependencias de frontend y PHP están incluidas en `src/customers/wwwroot/library/`; no existe un manifiesto raíz de Composer o npm.

## Módulos funcionales

Los nombres de archivos comienzan con un prefijo de tres letras que identifica el dominio. Los módulos con mayor presencia son:

| Prefijo | Dominio |
| --- | --- |
| `SYS` | Sistema, seguridad, permisos, documentos y configuración |
| `GRL` | Datos y servicios compartidos |
| `HLT` | Salud |
| `HHR` | Recursos humanos |
| `STK` | Stock, depósitos y materiales |
| `SLS` | Ventas |
| `FIN` | Finanzas |
| `EDU` | Educación |
| `SPT` | Deporte |
| `BUY` | Compras |
| `TSR` | Tesorería |
| `LOG` | Logística |
| `CRM` | Relaciones con clientes |
| `CNS` | Construcción/proyectos |
| `ADM` | Administración |
| `ZCU` | Personalizaciones por cliente |
| `GAS` | Gastronomía |

## Base de datos

La carpeta se denomina deliberadamente `batabase` por la estructura actual del repositorio. Contiene los artefactos necesarios para analizar una funcionalidad sin conectarse a SQL Server:

- `src/batabase/tmssTables/`: una tabla por script, por ejemplo `dbo.ADM_BUS.Table.sql`.
- `src/batabase/tmssFunctions/`: funciones reutilizables, entre ellas autorización, restricciones por usuario, conversión y construcción de consultas.
- `src/batabase/tmmsStored/`: procedimientos de negocio, por ejemplo `dbo.ADM_BUS_DEF.StoredProcedure.sql`.

Los scripts están codificados mayormente como **UTF-16 LE**. No deben convertirse a UTF-8 al editarlos: hacerlo genera diffs masivos y puede afectar su ejecución en SQL Server.

### Convenciones SQL

El modelo PHP `admbus` ilustra el vínculo entre capas:

```text
src/customers/tmssOnLine/controller/admbus.php
  → src/customers/tmssOnLine/model/admbus.php
    → src/batabase/tmmsStored/dbo.ADM_BUS_DEF.StoredProcedure.sql
      → src/batabase/tmssTables/dbo.ADM_BUS.Table.sql
```

La mayoría de los procedimientos recibe `@lp_sysoperation`. Las operaciones frecuentes son:

| Código | Uso habitual |
| --- | --- |
| `01` | alta |
| `02` | modificación |
| `03` | consulta individual |
| `04` | baja |
| `08` | listado |
| `11`, `12`, `13`, `14`, `18` | variantes internas; revisar cada procedimiento antes de utilizarlas |

La autorización se resuelve principalmente en SQL con `dbo.CheckAuthorization`, y los listados suelen utilizar `dbo.GetSQLSentence` y `dbo.GetUserRestrictions`. Una modificación debe conservar o reforzar esos controles; nunca asumir que el control del controlador PHP es suficiente.

No existe un mecanismo de migraciones ni un runner de SQL versionado. Para instalar o revisar un cambio manualmente, verificar dependencias y aplicar, como regla general, el orden **tablas → funciones → procedimientos**. Cada script contiene además su propio `USE`, `CREATE` y dependencias que deben revisarse antes de ejecutarlo.

## Requisitos y configuración local

### Requisitos

- PHP 8.1 o posterior.
- Extensión de PHP `sqlsrv` habilitada.
- SQL Server accesible desde el host PHP.
- Un servidor web configurado con document root en `src/customers/wwwroot/`.
- Permiso de escritura para el usuario del servidor web en `src/customers/system/logs/`.

### Configuración inicial

1. Crear el directorio de logs si aún no existe.
2. Copiar `src/engine/tmssDatabaseCfg.example.php` a `src/customers/system/engine/tmssDatabaseCfg.php`.
3. Completar servidor, base, usuario y contraseña en el archivo local creado.
4. Mantener ese archivo fuera de los commits y verificar que el mecanismo local de ignore lo cubra antes de trabajar con secretos.
5. Configurar el virtual host para servir únicamente `src/customers/wwwroot/`.

La configuración general se carga desde `src/customers/system/config/tmssOnLine.php`. No usar sus valores de clientes ni datos de conexión como plantilla de secretos nuevos.

## Puntos de entrada

| Archivo | Finalidad |
| --- | --- |
| `src/customers/wwwroot/index.php` | Aplicación web principal y layout autenticado. |
| `src/customers/wwwroot/indexcmd.php` | Ejecuciones orientadas a parámetros o línea de comandos. |
| `src/customers/wwwroot/api.gorse.php` | API JSON. |
| `src/customers/wwwroot/gorse.php` | Punto de acceso Gorse. |
| `src/customers/wwwroot/gorse.task.php` | Ejecución de tareas Gorse. |
| `src/customers/wwwroot/clientes/index.php` | Página de acceso por cliente. |
| `src/customers/wwwroot/indexfcb.php` | Integración histórica con Facebook. |

Los puntos de entrada auxiliares no deben exponerse ni modificarse sin revisar su mecanismo de autenticación y las acciones que permiten despachar.

## Desarrollo

La guía de desarrollo, convenciones de código, reglas para cambios SQL y formato de commits se encuentra en [DEVELOPMENT.md](DEVELOPMENT.md).

## Validación y despliegue

Los pasos de validación, despliegue y la limitación actual de no contar con pruebas automatizadas ni CI están centralizados en [DEVELOPMENT.md](DEVELOPMENT.md#validación).

## Consideraciones de seguridad y mantenimiento

- La autorización depende en gran medida de los procedimientos y funciones SQL; cualquier análisis sin base en ejecución debe leer esos scripts junto con el controlador y modelo involucrados.
- Hay despacho dinámico de controladores y puntos de entrada auxiliares. Su superficie debe revisarse antes de habilitar nuevos programas o acciones.
- El repositorio incluye una gran cantidad de bibliotecas de terceros y varias versiones históricas de algunas de ellas. No se gestionan mediante lockfiles, por lo que las actualizaciones deben planificarse e inventariarse explícitamente.
- El motor existe en dos ubicaciones. Cambiar el motor de runtime requiere editar `src/customers/system/engine/`; evaluar si una modificación debe replicarse en `src/engine/` para mantener ambas copias coherentes.
- El entorno de análisis actual no incluye PHP ni una conexión SQL Server; esta documentación se contrastó estáticamente contra el código PHP y los scripts de `src/batabase/`.

Para una descripción breve orientada al código fuente, consultar también [`src/README.md`](src/README.md).
