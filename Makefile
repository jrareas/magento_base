# Defaults settings (when building locally)
SHELL := /bin/sh

GCP_REGISTRY=us.gcr.io/minhamaedizia
IMAGE_NAME=$(GCP_REGISTRY)/magento_base_magento_base

-include variables.sh

variables.sh: ##
	unzip -o -P $(ZIP_SECRET) variables.zip

help:	 ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fg

build:   ## build the image
	docker build \
		--build-arg MAGENTO_PUB_KEY=$(MAGENTO_PUB_KEY) \
		--build-arg MAGENTO_PRIV_KEY=$(MAGENTO_PRIV_KEY) \
		-t $(IMAGE_NAME) .

push:    ## push the image to the docker registry
	docker push $(IMAGE_NAME)

tag: ## Tag the built image with the tag name (make tag TAG_VER=xxx)
	docker tag $(IMAGE_NAME) $(IMAGE_NAME)

pull:    ## pull an image from the docker registry
	docker pull $(IMAGE_NAME):$(TAG_NAME)

update: ## Update the code for all repositories
	docker run \
	  -v $(PWD)/tulip.yaml:/workspace/tulip.yaml \
	  -v $(PWD)/tulip.lock:/workspace/tulip.lock \
	  -e USER_ID=$(HOST_USER_ID) -e GROUP_ID=$(HOST_GROUP_ID) \
	  $(PLATFORM_BUILDER_IMAGE) oleander generate-lock

ci-build: build

ci-test:
	echo "no tests"
