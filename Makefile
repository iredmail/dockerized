ROOT := $(shell realpath .)
BUILD ?= build
DOCKERFILES_PATH := $(ROOT)/Dockerfiles
DOCKERFILE_ALL := $(DOCKERFILES_PATH)/Dockerfile

DOCKER_CMD ?= $(shell (type podman > /dev/null 2>&1 && echo "podman") || (type docker > /dev/null 2>&1 && echo "docker") || echo podman)
DOCKER_REPO ?= localhost:5000
DOCKER_IMAGE_TAG ?= latest
DOCKER_IMAGE_GROUP ?= iredmail
DOCKER_IMAGE_NAME ?= $(DOCKER_IMAGE_GROUP)/mariadb:$(DOCKER_IMAGE_TAG)
DOCKER_IMAGES_LIST = antispam dovecot iredapd mariadb postfix sogo

.PHONY: build send clean build-all
build-all:
	for i in $(DOCKER_IMAGES_LIST); do \
		echo Building the $$i container ; \
        $(DOCKER_CMD) build -t $(DOCKER_IMAGE_GROUP)/$$i:$(DOCKER_IMAGE_TAG) -f $(DOCKERFILES_PATH)/$$i . ; \
    done

clean:
	$(RM) -r $(BUILD)
	$(DOCKER_CMD) rmi $(shell $(DOCKER_CMD) images --format '{{.Repository}}:{{.Tag}}' | grep $(DOCKER_IMAGE_GROUP))

build: $(DOCKERFILE_ALL)
	$(DOCKER_CMD) build -t $(DOCKER_IMAGE_NAME) -f $(DOCKERFILE_ALL) .

send: build
	$(DOCKER_CMD) tag $(DOCKER_IMAGE_NAME) $(DOCKER_REPO)/$(DOCKER_IMAGE_NAME)
	$(DOCKER_CMD) push $(DOCKER_REPO)/$(DOCKER_IMAGE_NAME)
