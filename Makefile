default: build
build: docker_build output
release: docker_build docker_push output

# Image and binary can be overidden with env vars.
DOCKER_IMAGE ?= jrdasm/nginx-fancy
CODE_VERSION = $(strip $(shell grep '^FROM ' Dockerfile|tail -n1|cut -d: -f2))
GIT_COMMIT = $(strip $(shell git rev-parse --short HEAD))
GIT_NOT_CLEAN_CHECK = $(shell git status --porcelain)
ifeq ($(MAKECMDGOALS),release)
ifneq (x$(GIT_NOT_CLEAN_CHECK), x)
$(error echo You are trying to release a build based on a dirty repo)
endif
DOCKER_TAG = $(CODE_VERSION)
else
ifneq (x$(GIT_NOT_CLEAN_CHECK), x)
DOCKER_TAG_SUFFIX = "-dirty"
endif
DOCKER_TAG = $(CODE_VERSION)$(DOCKER_TAG_SUFFIX)
endif

docker_build:
	# Build Docker image
	docker build \
	  --build-arg VERSION=$(CODE_VERSION) \
	  --build-arg BUILD_DATE=`date -u '+%FT%TZ'` \
	  --build-arg VCS_REF=$(GIT_COMMIT) \
	  --build-arg VCS_URL=`git config --get remote.origin.url` \
	  -t $(DOCKER_IMAGE):$(DOCKER_TAG) .

docker_push:
	# Push to DockerHub
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)

output:
	@echo Docker Image: $(DOCKER_IMAGE):$(DOCKER_TAG)
