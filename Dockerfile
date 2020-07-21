FROM debian:buster-slim

RUN sed -i "s@http://deb.debian.org@http://mirrors.cloud.tencent.com@g" /etc/apt/sources.list \
 && sed -i "s@http://ftp.debian.org@http://mirrors.cloud.tencent.com@g" /etc/apt/sources.list \
 && sed -i "s@http://security.debian.org@http://mirrors.cloud.tencent.com@g" /etc/apt/sources.list
 
RUN apt update  \
 && apt install -y curl gnupg2 \
 && echo "deb http://nginx.org/packages/debian buster nginx" | tee /etc/apt/sources.list.d/nginx.list  \
 && curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -  \
 && apt update  \
 && apt install -y nginx  \
 && apt install -y cron apt-mirror  \
 && apt remove -y gnupg2 ca-certificates lsb-release \
 && apt autoremove -y && apt clean && rm -rf /var/lib/apt/lists* /tmp/* /var/tmp/* 

COPY docker-entrypoint.sh /docker/


VOLUME ["/var/spool/apt-mirror"]

ENTRYPOINT ["/docker/docker-entrypoint.sh"]
CMD ["cron"]
