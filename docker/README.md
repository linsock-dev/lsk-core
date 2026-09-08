# Despliegue con Docker

Hay dos despliegues alternativos de la aplicación: uno basado en Alpine y otro
en Debian. Ambos levantan un contenedor Nginx y uno PHP-FPM 8.3 con los drivers
Microsoft ODBC 18 y las extensiones `sqlsrv` y `pdo_sqlsrv` requeridas por la
aplicación. No incluyen SQL Server: el servidor debe estar accesible desde el
contenedor PHP.

No ejecute los dos perfiles en el mismo puerto a la vez. Los nombres de proyecto,
redes y volúmenes son distintos para que no compartan logs accidentalmente.

## Preparación común

Antes de construir la imagen, la configuración estándar de la aplicación debe
estar disponible en `src/customers/system/engine/tmssDatabaseCfg.php` y debe
apuntar al core, no a una base de cliente. Docker no crea, copia ni monta ese
archivo de forma separada: el `COPY src/customers` del Dockerfile toma el árbol
de la aplicación tal como está.

En tiempo de ejecución, la aplicación consulta `SYS_CNX` en el core mediante
`SYS_CNX_DEF` y con el identificador `bsecnx` abre la base del cliente. Por ello,
el contenedor PHP necesita conectividad al core y a todas las bases de clientes
habilitadas. Cada cliente requiere una fila activa en `SYS_CNX` cuyos datos de
servidor, base y credenciales sean válidos. Si SQL Server usa un certificado
interno o autofirmado, instale su CA en la imagen antes de producción; no
desactive la validación TLS como solución permanente.

Como el archivo forma parte de la imagen resultante, trátela como un artefacto
privado: no la publique en un registro público. Todo cambio de la configuración
requiere reconstruir el servicio con `up -d --build`.

Opcionalmente, defina las variables de entorno antes de iniciar:

```sh
export HTTP_PORT=8080
export TZ=America/Argentina/Buenos_Aires
```

`HTTP_PORT` publica Nginx en el host (por defecto `8080`). `TZ` se inyecta al
contenedor PHP y por defecto usa `America/Argentina/Buenos_Aires`.

## Variante Alpine

Use esta variante si la prioridad es una imagen PHP más compacta. Microsoft
publica el paquete ODBC para Alpine en las arquitecturas `amd64` y `arm64`.

```sh
docker compose -f docker/alpine/docker-compose.yml build
docker compose -f docker/alpine/docker-compose.yml up -d
docker compose -f docker/alpine/docker-compose.yml ps
docker compose -f docker/alpine/docker-compose.yml logs -f
```

La aplicación queda disponible en `http://localhost:${HTTP_PORT:-8080}`. Para
actualizar el código, vuelva a construir y recree los servicios:

```sh
docker compose -f docker/alpine/docker-compose.yml up -d --build
```

Para detenerla sin borrar los logs persistentes:

```sh
docker compose -f docker/alpine/docker-compose.yml down
```

Para borrar también los logs de aplicación (acción irreversible):

```sh
docker compose -f docker/alpine/docker-compose.yml down -v
```

## Variante Debian

Use esta variante cuando se prefiera la base Debian y el repositorio APT de
Microsoft para el driver ODBC.

```sh
docker compose -f docker/debian/docker-compose.yml build
docker compose -f docker/debian/docker-compose.yml up -d
docker compose -f docker/debian/docker-compose.yml ps
docker compose -f docker/debian/docker-compose.yml logs -f
```

La actualización y detención siguen el mismo esquema:

```sh
docker compose -f docker/debian/docker-compose.yml up -d --build
docker compose -f docker/debian/docker-compose.yml down
```

Para eliminar también el volumen de logs, use `down -v`.

## Verificación y operación

Confirme que las extensiones necesarias están cargadas:

```sh
docker compose -f docker/debian/docker-compose.yml exec php php -m | grep -E '^(sqlsrv|pdo_sqlsrv)$'
```

Cambie `debian` por `alpine` si corresponde. El healthcheck de PHP verifica
esas extensiones, pero no intenta autenticarse contra SQL Server. Para
diagnosticar conectividad, consulte los logs de la aplicación:

```sh
docker compose -f docker/debian/docker-compose.yml logs -f php nginx
```

Los logs propios de la aplicación persisten en el volumen `lsk-core-<variante>-logs`.
Las imágenes de PHP y Nginx se construyen con la misma revisión del código; Nginx
expone únicamente `/var/www/customers/wwwroot`. PHP utiliza el archivo de
credenciales del core que ya está en
`src/customers/system/engine/tmssDatabaseCfg.php` al momento de construir la
imagen y resuelve las conexiones de clientes desde `SYS_CNX`.

Antes de exponer el puerto a Internet, publique Nginx detrás de un proxy TLS o
añada certificados y una configuración HTTPS. Ajuste los límites de PHP y
`client_max_body_size` en `docker/php/conf.d/zz-lsk-core.ini` y
`docker/nginx/default.conf` si el tamaño esperado de adjuntos lo requiere.
