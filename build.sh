#!/bin/bash

set -e

GOOS=${GOOS:-linux}
GOARCH=${GOARCH:-amd64}

POCKETBASE_VERSION=${POCKETBASE_VERSION:-0.28.4}
# POCKETBASE_URL=https://github.com/pocketbase/pocketbase/archive/refs/heads/master.tar.gz
POCKETBASE_URL=https://github.com/pocketbase/pocketbase/archive/refs/tags/v$POCKETBASE_VERSION.tar.gz
POCKETBASE_TGZ=pocketbase.tar.gz

mkdir -p temp
pushd temp
if [ -f $POCKETBASE_TGZ ]; then
  echo Code is already downloaded
else
  echo Downloading: $POCKETBASE_URL
  curl -fsSLo $POCKETBASE_TGZ $POCKETBASE_URL
  tar xvf $POCKETBASE_TGZ
fi
popd

cd temp/pocketbase-$POCKETBASE_VERSION
patch -p1 -Ni ../../patches/s3.patch || true
echo Building pocketbase-$GOOS-$GOARCH
env CGO_ENABLED=0 go build -ldflags "-s -w" -trimpath -o ../../bin/pocketbase-$GOOS-$GOARCH ./examples/base/main.go
