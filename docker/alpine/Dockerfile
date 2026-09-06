FROM php:8.3-fpm-alpine3.22

ARG TARGETARCH
ARG ODBC_VERSION=18.6.2.1-1

RUN set -eux; \
    case "${TARGETARCH}" in amd64|arm64) ;; *) echo "Arquitectura no soportada: ${TARGETARCH}" >&2; exit 1 ;; esac; \
    apk add --no-cache \
        curl \
        curl-dev \
        freetype-dev \
        icu-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libxml2-dev \
        libzip-dev \
        linux-headers \
        oniguruma-dev \
        openssl-dev \
        unixodbc-dev; \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS; \
    curl -fsSLo /tmp/msodbcsql18.apk "https://download.microsoft.com/download/0b3d5518-b4a7-4a2b-afc7-7ee9e967f93c/msodbcsql18_${ODBC_VERSION}_${TARGETARCH}.apk"; \
    apk add --no-cache --allow-untrusted /tmp/msodbcsql18.apk; \
    rm /tmp/msodbcsql18.apk; \
    docker-php-ext-configure gd --with-freetype --with-jpeg; \
    docker-php-ext-install -j"$(nproc)" curl ftp gd intl mbstring opcache soap zip; \
    pecl install sqlsrv pdo_sqlsrv; \
    docker-php-ext-enable sqlsrv pdo_sqlsrv; \
    apk del .build-deps

COPY docker/php/conf.d/zz-lsk-core.ini /usr/local/etc/php/conf.d/zz-lsk-core.ini
COPY src/customers /var/www/customers

RUN set -eux; \
    mkdir -p /var/www/customers/system/logs; \
    chown -R www-data:www-data /var/www/customers/system/logs

WORKDIR /var/www/customers/wwwroot
