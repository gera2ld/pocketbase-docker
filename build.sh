#!/bin/bash

set -e

GOOS=${GOOS:-linux}
GOARCH=${GOARCH:-amd64}
POCKETBASE_VERSION=${POCKETBASE_VERSION:-0.41.0}

# binary: use the official release binary. source: compile from source (e.g. when patching).
MODE=${MODE:-binary}

OUTPUT=$PWD/bin/pocketbase-$GOOS-$GOARCH

download() {
  local url=$1
  local out=$2
  if [ -f $out ]; then
    echo Already downloaded: $url
  else
    echo Downloading: $url
    curl -fLo $out $url
  fi
}

build_from_binary() {
  local url=https://ganigeorgiev.com/meta/pocketbase/pocketbase/download/v$POCKETBASE_VERSION/pocketbase_${POCKETBASE_VERSION}_${GOOS}_${GOARCH}.zip
  local dir=temp/pocketbase-$POCKETBASE_VERSION-$GOOS-$GOARCH

  mkdir -p $dir bin
  download $url $dir/pocketbase.zip
  unzip -oq $dir/pocketbase.zip pocketbase -d $dir
  mv $dir/pocketbase $OUTPUT
}

build_from_source() {
  local url=https://ganigeorgiev.com/api/git/pocketbase/pocketbase/archive?rev=refs%2Ftags%2Fv$POCKETBASE_VERSION
  local source=pocketbase.zip

  mkdir -p temp
  download $url temp/$source
  unzip -oq temp/$source -d temp/src

  echo Building pocketbase-$GOOS-$GOARCH
  pushd temp/src
  env CGO_ENABLED=0 GOOS=$GOOS GOARCH=$GOARCH go build -ldflags "-s -w" -trimpath -o $OUTPUT ./examples/base/main.go
  popd
}

case $MODE in
  binary) build_from_binary ;;
  source) build_from_source ;;
  *) echo "Unknown MODE: $MODE" >&2; exit 1 ;;
esac
