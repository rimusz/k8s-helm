default: build

DOCKER_IMAGE ?= quay.io/rimusz/k8s-helm
include TAG

build:
	@.scripts/set_tag.sh
	docker build \
	  --build-arg VCS_REF=`git rev-parse --short HEAD` \
	  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	  -t $(DOCKER_IMAGE):$(HELM_TAG) -t $(DOCKER_IMAGE):latest .

push:
	# Push to DockerHub
	docker push $(DOCKER_IMAGE):$(HELM_TAG)

test:
	docker run $(DOCKER_IMAGE):$(HELM_TAG) version --client

tag:
	@.scripts/set_tag.sh

all: build test push
