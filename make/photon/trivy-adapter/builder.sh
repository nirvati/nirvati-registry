#!/bin/bash

set +e

VERSION="0.64.1"
ADAPTER_VERSION="v0.33.2"
GOBUILDIMAGE="golang:1.24.6"

set -e

cd $(dirname $0)
cur=$PWD

echo "Downloading static Trivy binary ..."
STATIC_BINARY_URL="https://github.com/aquasecurity/trivy/releases/download/v$VERSION/trivy_${VERSION}_Linux-64bit.tar.gz"
mkdir -p binary
curl -L $STATIC_BINARY_URL | tar -xz -C binary
# The temporary directory to clone Trivy adapter source code
TEMP=$(mktemp -d ${TMPDIR-/tmp}/trivy-adapter.XXXXXX)
git clone https://github.com/goharbor/harbor-scanner-trivy.git $TEMP
cd $TEMP; git checkout $ADAPTER_VERSION; cd -

echo "Building Trivy adapter binary ..."
cp Dockerfile.binary $TEMP
docker buildx build --build-arg golang_image=$GOBUILDIMAGE -f $TEMP/Dockerfile.binary -t trivy-adapter-golang --load $TEMP

echo "Copying Trivy adapter binary from the container to the local directory..."
ID=$(docker create trivy-adapter-golang)
docker cp $ID:/go/src/github.com/goharbor/harbor-scanner-trivy/scanner-trivy binary/scanner-trivy

docker rm -f $ID
docker rmi -f trivy-adapter-golang

echo "Building Trivy adapter binary finished successfully"
cd $cur
rm -rf $TEMP
