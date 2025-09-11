FROM debian:bullseye

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    nginx \
 && rm -rf /var/lib/apt/lists/*

COPY www/ /var/www/static/
COPY --chown=www-data:www-data www/ /var/www/static/

# Replace default config
RUN rm /etc/nginx/sites-enabled/default
RUN echo 'server { \
    listen 80; \
    root /var/www/static; \
    index index.html; \
    server_name _; \
}' > /etc/nginx/sites-enabled/static.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
