# Repository Guidelines

## Estructura y arquitectura

El sistema principal está en `src/`. La aplicación desplegable vive en `src/customers/`: `wwwroot/` es el document root; `system/engine/` contiene el framework PHP cargado en runtime; y `tmssOnLine/` organiza `controller/`, `model/`, vistas `.frm` y recursos de idioma. Las bibliotecas y assets están versionados en `wwwroot/library/`; no existe instalación raíz con Composer o npm. `src/engine/` es una copia de soporte y contiene `tmssDatabaseCfg.example.php`.

Siga siempre el flujo `index.php → controller → model → stored procedure → tablas/funciones`. Sin una base accesible, los scripts de `src/batabase/` son la fuente de verdad: `core/` describe la base central (configuración, suscripciones y conexiones) y `customers/` la base operativa de cada cliente. Mantenga ambos grupos separados. `docker/` ofrece despliegues opcionales; no es el código principal.

## Desarrollo y validación

El entorno requiere PHP 8.1+, `sqlsrv`, SQL Server y un servidor web apuntando a `src/customers/wwwroot/`.

- `git diff --check`: detecta errores de espacios.
- `rg --files src/customers -g '*.php' | rg -v '/library/' | xargs -n 1 php -l`: valida sintaxis PHP propia.
- `docker compose -f docker/debian/docker-compose.yml config`: valida el despliegue opcional; cambie `debian` por `alpine` cuando corresponda.
- `docker compose -f docker/debian/docker-compose.yml up -d --build`: construye e inicia la variante Docker.

No hay pruebas automatizadas, framework de testing ni CI. Pruebe manualmente autenticación, permisos, sesión, listados, AJAX y el flujo modificado. Los cambios SQL deben validarse en una base no productiva, incluidos el core (conexión `0`), la base cliente y la resolución por `bsecnx`.

## Estilo y nombres

Respete el estilo local y evite reformateos masivos; la indentación histórica es mixta. Controllers, models y vistas comparten nombres funcionales en minúscula, por ejemplo `admbus.php` y `admbus.frm`. Las clases del motor comienzan con `tmss`. Conserve los prefijos PHP `$lp_` (parámetros), `$lv_` (locales), `$lo_` (objetos), `$co_` (propiedades) y `$vew_` (datos de vista). Los objetos SQL usan mayúsculas y guiones bajos; los procedimientos suelen terminar en `_DEF`. Preserve UTF-16 LE y los finales de línea existentes en scripts SQL.

## Commits, PR y seguridad

Use commits breves en español: `tipo(alcance): resumen`, por ejemplo `fix(auth): validar sesión`; prefiera `feat`, `fix`, `refactor`, `docs`, `test`, `chore` o `security`, con asunto menor a 72 caracteres. El PR debe describir impacto, módulos y objetos SQL afectados, validación realizada, issue relacionado y capturas para cambios visuales. Nunca incluya `tmssDatabaseCfg.php`, credenciales, tokens, logs ni datos de clientes.
