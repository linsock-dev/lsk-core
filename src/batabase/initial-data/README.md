# Datos iniciales

Esta carpeta contiene el bootstrap mínimo para conectar un core vacío con una base de cliente vacía y obtener un usuario administrador inicial. No sustituye la carga funcional completa de módulos, formularios, vistas, catálogos ni datos de negocio.

## Script disponible

[`001-bootstrap.sql`](001-bootstrap.sql) crea de forma idempotente los registros base para un cliente. No contiene credenciales ni contraseñas reales: se deben completar sus variables antes de ejecutarlo.

El script presupone que el core y la base del cliente residen en la misma instancia de SQL Server, de modo que las dos cargas se confirman en una transacción. Si la base del cliente está en otra instancia, ejecutar allí las sentencias del bloque `@CustomerSql` y luego registrar la fila de `SYS_CNX` y los datos de suscripción en el core. Esos pasos no pueden formar una única transacción entre instancias sin una configuración adicional de SQL Server.

## Orden de instalación

1. Crear las bases de datos indicadas por los encabezados `USE` de los scripts: actualmente `tmssSysPrd` para el core y `tmssTeam2` para el cliente.
2. Instalar el core desde [`../core/`](../core/): tablas, las funciones `*.UserDefinedFunction.sql` y los procedimientos de `tmmsStored/`.
3. Instalar la base del cliente desde [`../customers/`](../customers/): tablas, funciones y procedimientos.
4. Editar los parámetros del inicio de [`001-bootstrap.sql`](001-bootstrap.sql), en especial los códigos, el servidor, las credenciales de SQL Server y la contraseña inicial.
5. Ejecutar el script con una cuenta que pueda insertar en ambas bases.
6. Crear o ajustar la entrada correspondiente en `src/customers/system/config/tmssOnLine.php`. Su campo `connection` debe ser exactamente el mismo valor que `@ConnectionCode` y `buscod` debe coincidir con `@CustomerBusinessCode`.
7. Configurar [tmssDatabaseCfg.php](../../customers/system/engine/tmssDatabaseCfg.php) para conectarse al core, nunca directamente a la base del cliente.

Los valores de `@CoreDatabase` y `@CustomerDatabase` deben coincidir con las bases realmente instaladas. Si se cambian, también se debe ejecutar o adaptar el esquema cuyos scripts contienen `USE` con esos nombres.

## Datos iniciales del core

El script inserta únicamente los registros que permiten resolver el cliente y habilitar la funcionalidad de alta de usuarios:

| Tabla | Datos creados | Finalidad |
| --- | --- | --- |
| `SYS_LNG` | Idioma `ES`, si no existe. | Registro del idioma usado por el bootstrap. Las traducciones de la aplicación se cargan desde archivos PHP. |
| `SYS_CNX` | Una conexión activa identificada por `SysCnxCodExt = @ConnectionCode`. | Indica servidor, base, usuario y contraseña de SQL Server de la base del cliente. |
| `SLS_CUS` | Un cliente central con `CusCodExt = @CustomerBusinessCode`. | Relaciona la suscripción funcional con el código de empresa de `ADM_BUS`. |
| `SYS_APP_MDL`, `SYS_APP_PRG`, `SYS_SEC_OPR` | Módulo `SYS`, programa `USR` y sus operaciones. | Publica el acceso inicial a usuarios en el menú. |
| `SYS_FNC`, `SYS_FNC_PRG`, `SYS_FNC_SUB` | Funcionalidad `BOOTSTRAP_SYS_USR`, operaciones y suscripción vigente. | Hace que el programa esté disponible para el cliente en el core. |

`SYS_CNX` guarda la contraseña de conexión del cliente. Restringir su lectura en SQL Server y usar una cuenta con permisos mínimos para esa base. El script no actualiza registros existentes: volver a ejecutarlo solo agrega los que falten.

## Datos iniciales de la base del cliente

| Tabla | Datos creados | Finalidad |
| --- | --- | --- |
| `ADM_BUS` | La empresa definida por `@CustomerBusinessCode`. | Contexto de empresa para sesiones y permisos. |
| `SYS_SEC_USR` | El usuario de arranque definido por `@BootstrapUser`. | Permite iniciar sesión. La contraseña se guarda como SHA-256 de la contraseña indicada, normalizada a mayúsculas. |
| `SYS_SEC_USR_BUS` | Asociación entre el usuario inicial y la empresa. | Permite seleccionar la empresa después del login. |
| `SYS_SEC_GRP`, `SYS_SEC_USR_GRP` | Grupo administrador y asignación del usuario. | Agrupa los permisos iniciales. |
| `SYS_SEC_PER` | Permisos del grupo sobre `SYS/USR`. | Permite usar la funcionalidad inicial suscripta por el core. |

El usuario creado tiene `UsrSysAcc = 0`, por lo que puede acceder a la interfaz web. Cambiar la contraseña inicial desde la aplicación inmediatamente después de validar el acceso. La pantalla de acceso por defecto envía SHA-256 de la contraseña en mayúsculas; usar caracteres ASCII para la contraseña inicial evita diferencias de normalización entre SQL Server y el navegador.

## Datos que siguen pendientes

El DDL disponible no contiene una exportación de los catálogos funcionales completos ni de los datos por cliente. Para habilitar otros módulos se deben cargar, según corresponda:

- módulos, programas, operaciones, funcionalidades y suscripciones adicionales en el core;
- permisos de cada rol en `SYS_SEC_PER` y autorizaciones de objeto en `SYS_SEC_PER_AUT`;
- vistas y columnas en `SYS_APP_PRG_VEW` y `SYS_APP_PRG_VEW_COL` cuando un programa usa la grilla genérica;
- directivas de acceso, configuraciones de documentos, parámetros, maestros y datos de negocio de la base del cliente.

La guía general de las dos conexiones está en el [README principal](../../../README.md#uso-de-las-dos-bases).
