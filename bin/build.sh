#!/bin/bash

set -eox pipefail

if [[ "${DEBUG}" == "true" ]]; then
  set -x
fi


farch=x64
darch=linux/amd64
# TODO: set mirror

if [[ "$ARCH" = "aarch64" ]]; then
  farch=arm64
  darch=linux/arm64
  export CC=aarch64-linux-gnu-gcc CXX=aarch64-linux-gnu-g++
fi

mkdir .cache

echo "Installing re2 v${VERSION} for Node v${NODE_VERSION} (${farch})"
npm install "re2@${VERSION}" --save-exact --no-audit --no-fund --prefix .cache --no-progress --platform-arch=${farch} --arch=${farch}

echo "Testing re2 v${VERSION} for Node v${NODE_VERSION} (${farch})"
docker pull --platform ${darch} "node:${NODE_VERSION}" > /dev/null 2>&1
docker run --rm \
  --platform ${darch} \
  -v "$(pwd)/.cache:/cache" \
  -w /cache \
  "node:${NODE_VERSION}" \
  node -e "new require('re2')('.*').exec('test') && console.log(process.arch)"

echo "Compressing re2 v${VERSION} for Node v${NODE_VERSION} (${farch})"
mod=$(node -e 'console.log(process.versions.modules)')
brotli -n -Z .cache/node_modules/re2/build/Release/re2.node -o ".cache/linux-${farch}-${mod}.br"

ls -la .cache
