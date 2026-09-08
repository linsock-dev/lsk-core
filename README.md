# LSK Core / TEMASIS

Aplicación web empresarial multiempresa desarrollada en PHP, con un MVC propio y SQL Server. La capa PHP entrega la interfaz y orquesta los casos de uso; el esquema, las reglas de negocio, las restricciones y la mayor parte de las consultas viven en scripts SQL versionados dentro del repositorio.

> Este proyecto no incluye una base de datos ejecutable ni una configuración local de conexión. Por lo tanto, el análisis y el desarrollo de la capa de datos deben basarse en los scripts de `src/batabase/`.

## Índice

- [Arquitectura](#arquitectura)
- [Estructura del repositorio](#estructura-del-repositorio)
- [Módulos funcionales](#módulos-funcionales)
- [Base de datos](#base-de-datos)
- [Requisitos y configuración local](#requisitos-y-configuración-local)
- [Despliegue con Docker](#despliegue-con-docker)
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
├── docker/                              # Despliegues Nginx + PHP-FPM
│   ├── alpine/                           # Perfil basado en Alpine
│   └── debian/                           # Perfil basado en Debian
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
        ├── core/                        # Base central del sistema
        │   ├── tmssTables/
        │   ├── tmssFunctions/
        │   └── tmmsStored/
        └── customers/                   # Base de cada cliente
            ├── tmssTables/
            ├── tmssFunctions/
            └── tmmsStored/
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

La carpeta se denomina deliberadamente `batabase` por la estructura actual del repositorio. Sus scripts están separados por la base de datos en la que deben ejecutarse:

| Base | Scripts | Uso |
| --- | --- | --- |
| Core | `src/batabase/core/` | Registro central del sistema, configuración y conexiones de clientes. Los scripts actuales usan `tmssSysPrd`. |
| Cliente | `src/batabase/customers/` | Datos y reglas de negocio de cada cliente. Los scripts actuales fueron exportados para `tmssTeam2`. |

Cada una contiene `tmssTables/` (tablas), `tmssFunctions/` (funciones) y `tmmsStored/` (stored procedures). Una funcionalidad de negocio habitual debe buscarse en `customers/`; los modelos que indican explícitamente el índice de conexión `0` usan el core.

### Uso de las dos bases

`tmssDatabaseCfg.php` no configura la base de un cliente: configura solamente el **core**. La aplicación abre esa conexión como índice `0` y la conserva para los módulos centrales.

Cuando un flujo necesita datos de un cliente, la aplicación toma `bsecnx` de la entrada o de la configuración del cliente, consulta en el core `SYS_CNX_DEF` con la operación `09` y busca una fila activa de `SYS_CNX` cuyo `SysCnxCodExt` coincida. Esa fila provee `SysCnxSrv`, `SysCnxDb`, `SysCnxUsr` y `SysCnxPwd`; con ellos se abre la conexión del cliente, normalmente en el índice `1`. Las llamadas que no especifican un índice se ejecutan sobre esa conexión de cliente.

```text
tmssDatabaseCfg.php
  → core (índice 0)
    → SYS_CNX_DEF('09', ..., bsecnx)
      → SYS_CNX: servidor, base y credenciales del cliente
        → base del cliente (índice 1)
```

Para registrar un cliente hacen falta dos referencias que deben usar el mismo `bsecnx`: la entrada de `src/customers/system/config/tmssOnLine.php` y una fila activa de `SYS_CNX` en el core. Sin esa fila la aplicación no puede abrir la base del cliente.

Los scripts crean objetos, pero actualmente no incluyen datos iniciales. La carga inicial del core, incluido `SYS_CNX`, se incorporará por separado.

### Instalación de esquemas

Los scripts incluyen su propio `USE`; crear antes la base de datos indicada en cada grupo y no mezclar scripts de `core/` y `customers/`. Para una instalación manual, aplicar cada grupo en el orden **tablas → funciones → procedimientos**, después de revisar dependencias.

En `src/batabase/core/tmssFunctions/` hay ocho funciones y copias de los 42 procedimientos de `core/tmmsStored/`. Al instalar el core, ejecutar las funciones `*.UserDefinedFunction.sql` de esa carpeta y los procedimientos desde `core/tmmsStored/`; ejecutar ambas copias de procedimientos provocaría errores de objeto ya existente.

Los scripts están codificados mayormente como **UTF-16 LE**. No deben convertirse a UTF-8 al editarlos: hacerlo genera diffs masivos y puede afectar su ejecución en SQL Server.

### Convenciones SQL

El modelo PHP `admbus` ilustra el vínculo entre capas:

```text
src/customers/tmssOnLine/controller/admbus.php
  → src/customers/tmssOnLine/model/admbus.php
    → src/batabase/customers/tmmsStored/dbo.ADM_BUS_DEF.StoredProcedure.sql
      → src/batabase/customers/tmssTables/dbo.ADM_BUS.Table.sql
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

No existe un mecanismo de migraciones ni un runner de SQL versionado. Cada script contiene además su propio `USE`, `CREATE` y dependencias que deben revisarse antes de ejecutarlo.

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
3. Completar servidor, base, usuario y contraseña del **core** en el archivo local creado.
4. Mantener ese archivo fuera de los commits y verificar que el mecanismo local de ignore lo cubra antes de trabajar con secretos.
5. Configurar el virtual host para servir únicamente `src/customers/wwwroot/`.

La configuración general se carga desde `src/customers/system/config/tmssOnLine.php`. Sus entradas de clientes aportan el identificador `connection` (`bsecnx`); las credenciales de cada cliente se resuelven desde `SYS_CNX` en el core. No usar esos valores como plantilla de secretos nuevos.

## Despliegue con Docker

El directorio [`docker/`](docker/README.md) contiene dos perfiles alternativos:
Nginx con PHP-FPM sobre Alpine o sobre Debian. Ambos incluyen PHP 8.3, ODBC 18 y
las extensiones `sqlsrv` y `pdo_sqlsrv`; SQL Server debe ser externo y accesible
desde el contenedor PHP.

El archivo de conexión sigue estando exclusivamente en su ubicación normal,
`src/customers/system/engine/tmssDatabaseCfg.php`. Debe contener las credenciales
del core y existir antes de construir la imagen. Durante la ejecución, el core
resuelve desde `SYS_CNX` la conexión de cada cliente; por eso el contenedor PHP
debe alcanzar tanto el core como las bases de clientes que utilizará. No hay
mounts, generación ni copias de ese archivo en Compose; el Dockerfile incorpora
el árbol `src/customers/` como aplicación.
Por contener credenciales, la imagen resultante debe tratarse como privada.

Desde la raíz del repositorio, por ejemplo para Debian:

```sh
docker compose -f docker/debian/docker-compose.yml up -d --build
```

Para Alpine, reemplace `debian` por `alpine`. La guía completa, incluidas
variables, logs, actualización y apagado, está en [`docker/README.md`](docker/README.md).

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

Los pasos de validación y la limitación actual de no contar con pruebas automatizadas ni CI están centralizados en [DEVELOPMENT.md](DEVELOPMENT.md#validación). Para los perfiles Nginx/PHP-FPM, consultar la guía de [Docker](docker/README.md).

## Consideraciones de seguridad y mantenimiento

- La autorización depende en gran medida de los procedimientos y funciones SQL; cualquier análisis sin base en ejecución debe leer esos scripts junto con el controlador y modelo involucrados.
- Hay despacho dinámico de controladores y puntos de entrada auxiliares. Su superficie debe revisarse antes de habilitar nuevos programas o acciones.
- El repositorio incluye una gran cantidad de bibliotecas de terceros y varias versiones históricas de algunas de ellas. No se gestionan mediante lockfiles, por lo que las actualizaciones deben planificarse e inventariarse explícitamente.
- El motor existe en dos ubicaciones. Cambiar el motor de runtime requiere editar `src/customers/system/engine/`; evaluar si una modificación debe replicarse en `src/engine/` para mantener ambas copias coherentes.
- El entorno de análisis actual no incluye PHP ni una conexión SQL Server; esta documentación se contrastó estáticamente contra el código PHP y los scripts de `src/batabase/`.

Para una descripción breve orientada al código fuente, consultar también [`src/README.md`](src/README.md).
