REPO ?= denstorti
VERSION ?= 0.0.12
IMAGE_NAME ?= cdktf-cli

build:
	docker build \
		--build-arg VERSION=${VERSION} \
		--tag "${IMAGE_NAME}:${VERSION}" \
		--tag "${IMAGE_NAME}:latest" \
		--tag "${REPO}/${IMAGE_NAME}:latest" \
		--tag "${REPO}/${IMAGE_NAME}:${VERSION}" \
		- < Dockerfile

push:
	docker push ${REPO}/${IMAGE_NAME}:${VERSION}
	docker push ${REPO}/${IMAGE_NAME}:latest

run: 
	docker run --rm ${IMAGE_NAME}:${VERSION}