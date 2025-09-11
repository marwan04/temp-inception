FROM debian:bullseye

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    php php-mysql wget ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# use a unique folder, not /var/www/html
WORKDIR /var/www/adminer

# download adminer
RUN wget https://www.adminer.org/latest.php -O index.php

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/adminer"]
