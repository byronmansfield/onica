BUILD_DATE ?= $(strip $(shell date -u +"%Y-%m-%dT%H:%M:%SZ"))
VERSION ?= $(shell cat VERSION)
GIT_COMMIT = $(strip $(shell git rev-parse --short HEAD))
GIT_URL ?= $(strip $(shell git config --get remote.origin.url))
VENDOR ?= bmansfield
APPNAME ?= onica
DOCKER_TAG ?= latest
DOCKER_IMG ?= $(VENDOR)/$(APPNAME):$(DOCKER_TAG)
DOCKERFILE_NGINX = Dockerfile.nginx
DOCKER_NGINX_IMG ?= $(VENDOR)/$(APPNAME):nginx_$(DOCKER_TAG)

all: docker_build docker_build_nginx

default: docker_build docker_build_nginx

# Docker build image
build: docker_build docker_build_nginx
build_app: docker_build
build_nginx: docker_build_nginx

# docker-compose
up: docker_compose_up
down: docker_compose_down

# publishing
publish: docker_hub_push

# build image which the app will run
docker_build:
	docker build \
		--no-cache=true \
		--force-rm \
		-t $(VENDOR)/$(APPNAME):$(GIT_COMMIT) \
		-t $(DOCKER_IMG) \
		app

docker_build_nginx:
	docker build \
		--no-cache=true \
		--force-rm \
		-t $(VENDOR)/$(APPNAME):nginx_$(GIT_COMMIT) \
		-t $(DOCKER_NGINX_IMG) \
		-f app/$(DOCKERFILE_NGINX) \
		app

docker_compose_up:
	docker-compose up -d

docker_compose_down:
	docker-compose down

docker_hub_push:
	docker push $(DOCKER_IMG)
	docker push $(DOCKER_NGINX_IMG)

.PHONY: docker_build docker_build_nginx docker_compose_up docker_compose_down docker_hub_push
