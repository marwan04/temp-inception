#!/bin/sh
set -eu

# ensure mount point exists
mkdir -p /var/www/html
chown -R www-data:www-data /var/www/html

# if wordpress is not installed in volume, copy it in
if [ ! -f /var/www/html/wp-config-sample.php ]; then
  echo "WordPress files not found in volume, copying..."
  tar -xzf /usr/src/wordpress.tar.gz -C /var/www/html --strip-components=1
  chown -R www-data:www-data /var/www/html
fi

# wait for db to be ready
echo "Waiting for MariaDB..."
until mariadb -h mariadb -u"${MYSQL_USER}" -p"$(cat /run/secrets/db_password)" -e "SELECT 1;" "${MYSQL_DATABASE}" >/dev/null 2>&1; do
  sleep 2
done

echo "MariaDB is ready, starting php-fpm..."
exec "$@"

