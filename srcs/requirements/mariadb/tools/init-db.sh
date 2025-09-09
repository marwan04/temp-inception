#!/bin/sh
set -eu

# Ensure runtime dirs
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Initialize data directory if empty
if [ ! -d /var/lib/mysql/mysql ]; then
  echo "Initializing MariaDB data directory..."
  mariadb-install-db --user=mysql --datadir=/var/lib/mysql --auth-root-authentication-method=normal

  # Start temporary server (local socket, no network)
  mysqld --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
  pid="$!"

  # Wait for server
  for i in $(seq 1 30); do
    if mysqladmin --socket=/run/mysqld/mysqld.sock ping >/dev/null 2>&1; then
      break
    fi
    sleep 1
  done

  ROOT_PWD="$(cat /run/secrets/db_root_password)"
  DB_PWD="$(cat /run/secrets/db_password)"

  # Create DB and user using env from .env
  mysql --protocol=socket --socket=/run/mysqld/mysqld.sock <<-EOSQL
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_PWD}';
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PWD}';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
    FLUSH PRIVILEGES;
EOSQL

  # Shutdown temp server
  mysqladmin --socket=/run/mysqld/mysqld.sock shutdown
  wait "$pid"
fi

# Exec the server in the foreground as PID 1
exec "$@"

