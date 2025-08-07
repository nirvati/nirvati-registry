#!/bin/bash

set +e

# TODO(Nirvati): Make this configurable/part of the CI config
VERSION="bunny"
DISTRIBUTION_SRC="https://github.com/nirvati/distribution.git"
GOBUILDIMAGE="golang:1.24.6"

set -e

# the temp folder to store binary file...
mkdir -p binary
rm -rf binary/registry || true

cd `dirname $0`
cur=$PWD

# the temp folder to store distribution source code...
TEMP=`mktemp -d ${TMPDIR-/tmp}/distribution.XXXXXX`
git clone -b $VERSION $DISTRIBUTION_SRC $TEMP

cd $cur

echo 'build the registry binary ...'
cp Dockerfile.binary $TEMP
docker buildx build --build-arg golang_image=$GOBUILDIMAGE -f $TEMP/Dockerfile.binary -t registry-golang --load $TEMP

echo 'copy the registry binary to local...'
ID=$(docker create registry-golang)
mkdir -p binary
docker cp $ID:/go/src/github.com/distribution/distribution/v3/bin/registry binary/registry

docker rm -f $ID
docker rmi -f registry-golang

echo "Build registry binary success, then to build photon image..."
cd $cur
cp $TEMP/cmd/registry/config-example.yml config.yml
rm -rf $TEMP
