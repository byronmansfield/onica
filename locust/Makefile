APPNAME ?= onica
DOCKER_TAG ?= locust
DOCKER_IMG ?= $(APPNAME):$(DOCKER_TAG)
COMPOSE_FILE ?= docker-compose.yml

all: docker_build

default: docker_build

build: docker_build

run: docker_compose_up
stop: docker_compose_down

# build docker image
docker_build:
	docker build \
		--no-cache=true \
		--force-rm \
		-t $(DOCKER_IMG) .

docker_compose_up:
	docker-compose -f $(COMPOSE_FILE) up --scale slave=2

docker_compose_down:
	docker-compose -f $(COMPOSE_FILE) down

.PHONY: docker_build docker_compose_up docker_compose_down
