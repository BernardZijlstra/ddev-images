#!/bin/bash

set -eu -o pipefail
set -x

sudo apt-get update && sudo apt-get install docker-ce-cli binfmt-support qemu-user-static

BUILDX_BINARY_URL="https://github.com/docker/buildx/releases/download/v0.4.2/buildx-v0.4.2.linux-amd64"

curl --output docker-buildx \
  --silent --show-error --location --fail --retry 3 \
  "$BUILDX_BINARY_URL"

mkdir -p ~/.docker/cli-plugins
mv docker-buildx ~/.docker/cli-plugins
chmod a+x ~/.docker/cli-plugins/docker-buildx

# We need this to get arm64 qemu to work https://github.com/docker/buildx/issues/138#issuecomment-569240559
docker run --rm --privileged docker/binfmt:66f9012c56a8316f9244ffd7622d7c21c1f6f28d
if ! docker buildx inspect ddev-builder-multi --bootstrap >/dev/null; then docker buildx create --name ddev-builder-multi; fi
docker buildx use ddev-builder-multi
