FROM bettercode/scurl:latest as scurl
FROM centos:7 as runner
COPY --from=scurl /usr/local/bin/scurl /usr/local/bin/scurl
COPY docker /docker
COPY . /.src/mirror-server


# build time, runtime toolchains/cli
RUN bash /.src/mirror-server/os/centos/mk-runner-cloud.sh


ENTRYPOINT ["/docker/docker-entrypoint.sh"]
CMD ["nginx"]
