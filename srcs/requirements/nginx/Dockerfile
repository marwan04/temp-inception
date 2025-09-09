FROM debian:bullseye

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    nginx openssl ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# create ssl cert/key (self-signed)
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
      -keyout /etc/nginx/ssl/nginx.key \
      -out /etc/nginx/ssl/nginx.crt \
      -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=42/CN=${DOMAIN_NAME:-localhost}"

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]

