FROM debian:bullseye

# No "latest" tag; penultimate Debian is allowed by the subject.
# Install MariaDB server + client and minimal tools
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      mariadb-server mariadb-client ca-certificates bash coreutils \
 && rm -rf /var/lib/apt/lists/*

# Config + init script
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/init-db.sh /usr/local/bin/init-db.sh
RUN chmod +x /usr/local/bin/init-db.sh

# Data dir owned by mysql
RUN mkdir -p /var/lib/mysql /run/mysqld \
 && chown -R mysql:mysql /var/lib/mysql /run/mysqld

EXPOSE 3306

# Proper foreground startup via our entrypoint (no tail/sleep/while-true hacks)
ENTRYPOINT ["/usr/local/bin/init-db.sh"]
CMD ["mysqld", "--user=mysql", "--port=3306", "--bind-address=0.0.0.0"]

