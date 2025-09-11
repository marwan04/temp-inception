FROM debian:bullseye

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    vsftpd \
 && rm -rf /var/lib/apt/lists/*

COPY conf/vsftpd.conf /etc/vsftpd.conf
COPY tools/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 21 21000-21010

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/vsftpd", "/etc/vsftpd.conf"]