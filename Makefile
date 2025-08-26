include .env

REPO ?= phillik747

CDKTF_VERSION: ${CDKTF_VERSION}
TF_VERSION: ${TF_VERSION}

IMAGE_NAME ?= cdktf-cli-pydeploy
DOCKER_HUB_TOKEN: ${DOCKER_HUB_TOKEN}

COMPOSE_ALPINE = docker compose run --rm alpine

.EXPORT_ALL_VARIABLES:

all: build run push

build:
	docker build \
		--build-arg CDKTF_VERSION=${CDKTF_VERSION} \
		--build-arg TF_VERSION=${TF_VERSION} \
		--tag "${IMAGE_NAME}:${CDKTF_VERSION}" \
		--tag "${IMAGE_NAME}:latest" \
		--tag "${REPO}/${IMAGE_NAME}:latest" \
		--tag "${REPO}/${IMAGE_NAME}:${CDKTF_VERSION}" \
		-f Dockerfile .

push:
	docker login --username ${REPO} --password ${DOCKER_HUB_TOKEN}
	docker push ${REPO}/${IMAGE_NAME}:${CDKTF_VERSION}
	#docker push ${REPO}/${IMAGE_NAME}:latest

run: 
	docker run --rm ${IMAGE_NAME}:${CDKTF_VERSION} cdktf --version
	docker run --rm ${IMAGE_NAME}:${CDKTF_VERSION} terraform --version

check_new_version:
	@echo "cdktf" && curl -sl https://api.github.com/repos/hashicorp/terraform-cdk/releases/latest | jq -r '.tag_name' | tr -d "v"
	@echo ""
	@echo "provider mso" && curl -sl https://api.github.com/repos/CiscoDevNet/terraform-provider-mso/releases/latest | jq -r '.tag_name' | tr -d "v"
	@echo ""
	@echo "provider aci" && curl -sl https://api.github.com/repos/CiscoDevNet/terraform-provider-aci/releases/latest | jq -r '.tag_name' | tr -d "v"
	@echo ""
	@echo "terraform" && curl -sl https://api.github.com/repos/hashicorp/terraform/releases/latest | jq -r '.tag_name' | tr -d "v"
# 	docker compose build alpine
# 	$(COMPOSE_ALPINE) bash scripts/check_new_version.sh
