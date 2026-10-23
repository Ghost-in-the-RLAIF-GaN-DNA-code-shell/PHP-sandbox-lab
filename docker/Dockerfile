FROM php:8.4.27-fpm-bookworm AS builder
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/*

FROM php:8.4.27-fpm-bookworm

# 1. Disable/Lock the root account completely inside the container
RUN chsh -s /sbin/nologin root \
    && passwd -l root

# 2. Create unprivileged www-data user and hardened directories
RUN groupadd --system --gid 1000 www-data \
    && useradd --system --uid 1000 --gid 1000 --home-dir /var/www --create-home --shell /sbin/nologin www-data \
    && mkdir -p /var/www/html /run/php /tmp/php-sandbox \
    && chown -R www-data:www-data /var/www /run/php /tmp/php-sandbox

# 3. Copy hardened configurations
COPY configs/php.ini /usr/local/etc/php/conf.d/99-php2shell-hardening.ini
COPY configs/www.conf /usr/local/etc/php-fpm.d/www.conf

WORKDIR /var/www/html
USER www-data

EXPOSE 9000

CMD ["php-fpm", "-F"]
