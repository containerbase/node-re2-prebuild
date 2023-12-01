#!/bin/bash

set -eo pipefail

if [[ "${DEBUG}" == "true" ]]; then
  set -x
fi


TOOL_VERSION=${VERSION}
farch=x64
darch=linux/amd64

if [[ "$ARCH" = "aarch64" ]]; then
  farch=arm64
  darch=linux/arm64
  sudo apt-get install -y gcc-aarch64-linux-gnu g++-aarch64-linux-gnu binutils-aarch64-linux-gnu
  export CC=arm-linux-gnueabihf-gcc CXX=arm-linux-gnueabihf-g++
fi

# echo "Prepare builder for ${ARCH}"
# docker build -t node-re2-builder --load --platform ${darch} .

mkdir .cache

echo "Installing re2 v${VERSION} for Node v${NODE_VERSION} (${farch})"
npm install "re2@${TOOL_VERSION}" --save-exact --no-audit --no-fund --prefix .cache --no-progress

ls -la .cache/node_modules/re2/build/Release

echo "Testing re2 v${VERSION} for Node v${NODE_VERSION} (${farch})"
docker pull node:20 > /dev/null
docker run --rm \
  --platform ${darch} \
  -v "$(pwd)/.cache:/cache" \
  -w /cache \
  node:20 \
  node -e "new require('re2')('.*').exec('test') && console.log(process.arch)"

echo "Compressing re2 v${VERSION} for Node v${NODE_VERSION} (${farch})"
mod=$(node -e 'console.log(process.versions.modules)')
#brotli -n -Z ".cache/linux-${farch}-${mod}" -o ".cache/linux-${farch}-${mod}.br"
brotli -n -Z .cache/node_modules/re2/build/Release/re2.node -o ".cache/linux-${farch}-${mod}.br"

ls -la .cache
