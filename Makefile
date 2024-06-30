IMAGE_NAME := rockylinux_minecraft_server
TAG := 9.3.1.21
CONTAINER_NAME := $(shell echo test_run_${IMAGE_NAME}_${TAG} | sed -e s/\\//_/g)
IMAGE_FILE_NAME := rockylinux_minecraft_server_${TAG}.tar

ContainerExists = "$(shell docker ps | grep ${CONTAINER_NAME})"

.PHONY: help
help:
	@echo ""
	@echo "  TARGETS"
	@echo "    build ... Build docker image ${IMAGE_NAME}"
	@echo "    save  ... Save docker image ${IMAGE_NAME}"
	@echo "    clean ... Clean docker image ${IMAGE_NAME}"
	@echo "    run   ... Run docker container using image ${IMAGE_NAME}"
	@echo "    stop  ... Stop docker container which was created by run target"
	@echo ""

.PHONY: build
build: Dockerfile
	docker build --rm -t ${IMAGE_NAME}:${TAG} .

.PHONY: save
save:
	docker save -o ${IMAGE_FILE_NAME} ${IMAGE_NAME}:${TAG}

.PHONY: clean
clean: stop
	docker rmi ${IMAGE_NAME}:${TAG}

.PHONY: run
run: stop
	# Create container
	docker run \
	-itd \
	--rm \
	-p 25565:25565 \
	--name ${CONTAINER_NAME} \
	${IMAGE_NAME}:${TAG}

	# Execute bash
	docker exec \
	-it \
	${CONTAINER_NAME} \
	/bin/bash

.PHONY: stop
stop:
ifneq (${ContainerExists}, "")
	@echo "!!! Container exists. Delete. !!!"
	docker stop \
	${CONTAINER_NAME}
else
	@echo "Container does not exist."
endif
