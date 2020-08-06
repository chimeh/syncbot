CUR_DIR := $(realpath $(dir $(realpath $(firstword $(MAKEFILE_LIST)))))
.PHONY: phony-all
phony-all: docker

.PHONY: docker
docker:
	bash ${CUR_DIR}/scripts/build-docker.sh ${CUR_DIR}/Dockerfile dev
