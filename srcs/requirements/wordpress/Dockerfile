FROM debian:bullseye
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    php-fpm php-mysql php-cli php-mbstring php-xml php-curl curl tar ca-certificates mariadb-client \
 && rm -rf /var/lib/apt/lists/*

# Create the PHP-FPM PID directory
RUN mkdir -p /run/php && chown www-data:www-data /run/php

WORKDIR /var/www/html
# download wordpress to /usr/src (not /var/www/html, to avoid overwrite by volume)
RUN curl -o /usr/src/wordpress.tar.gz https://wordpress.org/latest.tar.gz

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
EXPOSE 9000
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm7.4", "-F"]
