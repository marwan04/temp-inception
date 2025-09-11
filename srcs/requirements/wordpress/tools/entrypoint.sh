#!/bin/sh
set -eu

# ensure mount point exists
mkdir -p /var/www/html
chown -R www-data:www-data /var/www/html

# if wordpress not yet extracted into volume, copy
if [ ! -f /var/www/html/wp-config-sample.php ]; then
  echo "WordPress files not found in volume, extracting..."
  tar -xzf /usr/src/wordpress.tar.gz -C /var/www/html --strip-components=1
  chown -R www-data:www-data /var/www/html
fi

# wait for mariadb to be ready
echo "Waiting for MariaDB..."
until mariadb -h mariadb -u"${MYSQL_USER}" -p"$(cat /run/secrets/db_password)" -e "SELECT 1;" "${MYSQL_DATABASE}" >/dev/null 2>&1; do
  sleep 2
done

# configure wp-cli (skip if already installed)
if ! wp core is-installed --path=/var/www/html --allow-root; then
  echo "Configuring WordPress with wp-cli..."
  wp config create \
    --path=/var/www/html \
    --allow-root \
    --dbname="${MYSQL_DATABASE}" \
    --dbuser="${MYSQL_USER}" \
    --dbpass="$(cat /run/secrets/db_password)" \
    --dbhost="mariadb" \
    --dbprefix="${WORDPRESS_TABLE_PREFIX}"

  wp core install \
    --path=/var/www/html \
    --allow-root \
    --url="https://${DOMAIN_NAME}" \
    --title="Inception Project" \
    --admin_user="${WP_ADMIN_USER}" \
    --admin_password="$(cat /run/secrets/wp_admin_password)" \
    --admin_email="${WP_ADMIN_EMAIL}"
fi

# install & activate redis cache plugin if not already
if ! wp plugin is-installed redis-cache --path=/var/www/html --allow-root; then
  echo "Installing Redis Cache plugin..."
  wp plugin install redis-cache --activate --path=/var/www/html --allow-root

  # enable object cache
  wp redis enable --path=/var/www/html --allow-root
fi


echo "WordPress ready, starting php-fpm..."
exec "$@"
