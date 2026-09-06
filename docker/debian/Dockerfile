FROM php:8.3-fpm-bookworm

ENV ACCEPT_EULA=Y

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        freetds-dev \
        libcurl4-openssl-dev \
        libfreetype6-dev \
        libgssapi-krb5-2 \
        libicu-dev \
        libjpeg62-turbo-dev \
        libonig-dev \
        libpng-dev \
        libxml2-dev \
        libzip-dev \
        unixodbc-dev; \
    curl -fsSLo /tmp/packages-microsoft-prod.deb https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb; \
    dpkg -i /tmp/packages-microsoft-prod.deb; \
    rm /tmp/packages-microsoft-prod.deb; \
    apt-get update; \
    apt-get install -y --no-install-recommends msodbcsql18; \
    docker-php-ext-configure gd --with-freetype --with-jpeg; \
    docker-php-ext-install -j"$(nproc)" curl ftp gd intl mbstring opcache soap zip; \
    pecl install sqlsrv pdo_sqlsrv; \
    docker-php-ext-enable sqlsrv pdo_sqlsrv; \
    rm -rf /var/lib/apt/lists/*

COPY docker/php/conf.d/zz-lsk-core.ini /usr/local/etc/php/conf.d/zz-lsk-core.ini
COPY src/customers /var/www/customers

RUN set -eux; \
    mkdir -p /var/www/customers/system/logs; \
    chown -R www-data:www-data /var/www/customers/system/logs

WORKDIR /var/www/customers/wwwroot
