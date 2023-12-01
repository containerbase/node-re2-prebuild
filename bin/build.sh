#!/bin/bash

set -eo pipefail

farch=x64
darch=linux/amd64

if [[ "$ARCH" = "aarch64" ]]; then
  farch=arm64
  darch=linux/arm64
fi

if [[ "${DEBUG}" == "true" ]]; then
  set -x
fi

echo "Prepare builder for ${ARCH}"
docker build -t node-re2-builder --load --platform ${darch} .


echo "Building re2 v${VERSION} for Node v${NODE_VERSION} (${farch})"
mkdir .cache
docker run --rm -t \
  --platform ${darch} \
  -v "$(pwd)/.cache:/cache" \
  node-re2-builder \
  "${NODE_VERSION}"


mod=$(node -e 'console.log(process.versions.modules)')

echo "Compressing re2 v${VERSION} for Node v${NODE_VERSION} (${farch})"
brotli -Z ".cache/linux-${farch}-${mod}" -o ".cache/linux-${farch}-${mod}.br"

ls -la .cache
