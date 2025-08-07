SHELL := /bin/bash
BUILDPATH=$(CURDIR)
TOOLSPATH=$(BUILDPATH)/tools
IMAGENAMESPACE=goharbor
SWAGGER_IMAGENAME=$(IMAGENAMESPACE)/swagger
SWAGGER_VERSION=v0.31.0
SWAGGER=$(shell which docker) run --rm -u $(shell id -u):$(shell id -g) -v $(BUILDPATH):$(BUILDPATH) -w $(BUILDPATH) ${SWAGGER_IMAGENAME}:${SWAGGER_VERSION}
SWAGGER_GENERATE_SERVER=${SWAGGER} generate server --template-dir=$(TOOLSPATH)/swagger/templates --exclude-main --additional-initialism=CVE --additional-initialism=GC --additional-initialism=OIDC
SWAGGER_IMAGE_BUILD_CMD=$(shell which docker) build -f ${TOOLSPATH}/swagger/Dockerfile --build-arg GOLANG=golang:1.24.5 --build-arg SWAGGER_VERSION=${SWAGGER_VERSION} -t ${SWAGGER_IMAGENAME}:${SWAGGER_VERSION} .

# $1 the path of swagger spec
# $2 the path of base directory for generating the files
# $3 the name of the application
define swagger_generate_server
	@echo "generate all the files for API from $(1)"
	@rm -rf $(2)/{models,restapi}
	@mkdir -p $(2)
	@$(SWAGGER_GENERATE_SERVER) -f $(1) -A $(3) --target $(2)
endef

gen_apis:
	$(SWAGGER_IMAGE_BUILD_CMD)
	$(call swagger_generate_server,api/v2.0/swagger.yaml,src/server/v2.0,harbor)
