#!/bin/bash

set -e

GOOS=${GOOS:-linux}
GOARCH=${GOARCH:-amd64}
POCKETBASE_VERSION=${POCKETBASE_VERSION:-0.40.5}

# download: use the official release binary. source: compile from source (e.g. when patching).
MODE=${MODE:-download}

OUTPUT=$PWD/bin/pocketbase-$GOOS-$GOARCH

download() {
  local url=https://github.com/pocketbase/pocketbase/releases/download/v$POCKETBASE_VERSION/pocketbase_${POCKETBASE_VERSION}_${GOOS}_${GOARCH}.zip
  local dir=temp/pocketbase-$POCKETBASE_VERSION-$GOOS-$GOARCH

  mkdir -p $dir bin
  echo Downloading: $url
  curl -fsSLo $dir/pocketbase.zip $url
  unzip -oq $dir/pocketbase.zip pocketbase -d $dir
  mv $dir/pocketbase $OUTPUT
}

build_from_source() {
  local url=https://github.com/pocketbase/pocketbase/archive/refs/tags/v$POCKETBASE_VERSION.tar.gz
  # url=https://github.com/pocketbase/pocketbase/archive/refs/heads/master.tar.gz
  local tgz=pocketbase.tar.gz

  mkdir -p temp
  pushd temp
  if [ -f $tgz ]; then
    echo Code is already downloaded
  else
    echo Downloading: $url
    curl -fsSLo $tgz $url
    tar xvf $tgz
  fi
  popd

  pushd temp/pocketbase-$POCKETBASE_VERSION
  echo Building pocketbase-$GOOS-$GOARCH
  env CGO_ENABLED=0 GOOS=$GOOS GOARCH=$GOARCH go build -ldflags "-s -w" -trimpath -o $OUTPUT ./examples/base/main.go
  popd
}

case $MODE in
  download) download ;;
  source) build_from_source ;;
  *) echo "Unknown MODE: $MODE" >&2; exit 1 ;;
esac
