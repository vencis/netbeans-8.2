APP_VERSION = $(strip $(shell cat VERSION))
GIT_COMMIT = $(strip $(shell git rev-parse --short HEAD))

DOCKER_IMAGE ?= internetportal/netbeans-x11
DOCKER_TAG = $(APP_VERSION)

# Build Docker image
build: docker_build docker_tag output

# Build and push Docker image
release: docker_tag docker_push output

default: docker_build output

docker_build:
	@docker build \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		--build-arg VERSION=$(APP_VERSION) \
		--build-arg VCS_REF=$(GIT_COMMIT) \
		-t $(DOCKER_IMAGE):$(DOCKER_TAG) .

docker_tag:
	docker tag $(DOCKER_IMAGE):$(DOCKER_TAG) $(DOCKER_IMAGE):latest

docker_push:
	docker push $(DOCKER_IMAGE):latest
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)

output:
	@echo Docker Image: $(DOCKER_IMAGE):$(DOCKER_TAG)
