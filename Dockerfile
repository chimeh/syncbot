FROM bettercode/scurl:latest as scurl
FROM centos:7 as runner
COPY --from=scurl /usr/local/bin/scurl /usr/local/bin/scurl
RUN scurl -O /usr/local/bin/tini https://github.com/krallin/tini/releases/download/v0.19.0/tini-static-arm64 \
 && ln -s /usr/bin/tini /usr/local/bin/tini
COPY docker /docker
COPY . /.src/mirror-server


# build time, runtime toolchains/cli
RUN bash /.src/mirror-server/os/centos/mk-runner-cloud.sh


ENTRYPOINT ["/docker/docker-entrypoint.sh"]
CMD ["nginx"]
