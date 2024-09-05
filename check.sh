#!/usr/bin/env bash

# Checks for a new PocketBase release and dispatches a build if it has not been
# pushed to Docker Hub yet.
#
# Usage:
#   GH_TOKEN=... bash -o pipefail -c \
#     'curl -fsSL https://raw.githubusercontent.com/gera2ld/pocketbase-docker/main/check.sh | bash'

set -euo pipefail

UPSTREAM_REPO=pocketbase/pocketbase
WORKFLOW_REPO=gera2ld/pocketbase-docker
IMAGE_REPO=gera2ld/pocketbase

dockerTagExists() {
  curl -fs -o /dev/null "https://hub.docker.com/v2/repositories/$1/tags/$2"
}

echo "Checking $UPSTREAM_REPO"
LATEST_URL=$(curl -fsSL -o /dev/null -w '%{url_effective}' "https://github.com/$UPSTREAM_REPO/releases/latest")
VERSION=${LATEST_URL##*/}
VERSION=${VERSION#v}

if dockerTagExists "$IMAGE_REPO" "$VERSION"; then
  echo "$IMAGE_REPO:$VERSION is already built"
  exit 0
fi

echo "Building $IMAGE_REPO:$VERSION"
curl -fsS \
  -H 'Accept: application/vnd.github.everest-preview+json' \
  -H 'Content-type: application/json' \
  -H "Authorization: Bearer $GH_TOKEN" \
  -X POST \
  -d '{"event_type":"build","client_payload":{"version":"'"$VERSION"'"}}' \
  "https://api.github.com/repos/$WORKFLOW_REPO/dispatches"
