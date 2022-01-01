ARG NGINX_VERSION=1.19
FROM php:8.0-fpm as app_php

COPY . /var/www/symfony

RUN apt update \
    && apt install -y zlib1g-dev g++ git libicu-dev zip libzip-dev zip \
    && docker-php-ext-install intl opcache pdo pdo_mysql \
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip

RUN curl --insecure https://getcomposer.org/composer.phar -o /usr/bin/composer && chmod +x /usr/bin/composer

WORKDIR /var/www/symfony

FROM nginx:${NGINX_VERSION}-alpine as app_nginx

COPY docker/php-fpm/default.conf /etc/nginx/conf.d/
