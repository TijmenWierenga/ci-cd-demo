# Use official composer library to move the composer binary to the PHP container
FROM composer:1.8 AS composer

FROM php:7.3-apache as production
LABEL maintainer="twieren0@xs4all.net"

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends git libzip-dev && \
    docker-php-ext-install opcache zip && \
    docker-php-ext-enable opcache

# Copy the composer binary to the container
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Add the Apache configuration as the default enabled-site
COPY .docker/apache.conf /etc/apache2/sites-enabled/000-default.conf

# Create the project root folder and assign ownership to the pre-existing www-data user
RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www

# Use the pre-existing user 'www-data' for all non-root related actions
USER www-data
WORKDIR /var/www/html

# Copy just the composer dependencies to the container. This should lead to a more efficient
# build cache since the 'composer install' cache-layer should only break if one of these two
# files has changed.
COPY --chown=www-data composer.json composer.lock symfony.lock /var/www/html/

# Install all composer dependencies without running the autoloader and the scripts since these
# actions rely on the source files of the application.
# Also, volume mounting a bind-mounted cache to composer's /tmp folder helps speeding up the build
# since even when you break the cache by adding/removing a composer package, all previously installed
# packages are served from the mounted cache.
ENV COMPOSER_CACHE_DIR=/var/www/.composer
RUN composer install --no-autoloader --no-scripts

# Copy the rest of the source code to the container. Now, if source files are changed, the cache-layer
# breaks here and the only the 'composer dump-autoload' command will have to run again.
COPY --chown=www-data . /var/www/html/

# Create an optimized autoloader
RUN composer dump-autoload --optimize

# Start in production mode by default
ENV APP_ENV=prod

# Apache can only be started as root
USER root

HEALTHCHECK --interval=10s --timeout=2s CMD curl -f http://localhost/health || exit 1
