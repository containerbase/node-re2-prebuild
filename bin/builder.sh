#!/bin/bash

set -e

# shellcheck source=/dev/null
. /usr/local/containerbase/util.sh

# trim leading v
NODE_VERSION=${1#v}
TOOL_VERSION=${NODE_RE2_VERSION}

NAME=re2
ARCH=$(uname -p)
farch=x64

if [[ "$ARCH" = "aarch64" ]]; then
    farch=arm64
  fi

if [[ "${DEBUG}" == "true" ]]; then
  set -x
fi

check_semver "${NODE_VERSION}" all
check_semver "${TOOL_VERSION}" all

echo "Building ${NAME} ${TOOL_VERSION} for Node ${NODE_VERSION} ${ARCH}"

install-tool node "${NODE_VERSION}"

npm install "${NAME}@${TOOL_VERSION}" --save-exact --no-audit --no-fund --prefix /build

mod=$(node -e 'console.log(process.versions.modules)')

cp node_modules/re2/build/Release/re2.node "/cache/linux-${farch}-${mod}"

# tar -C "/usr/local/${NAME}/${TOOL_VERSION}" --strip 1 -xf "${file}"

# "/usr/local/${NAME}/${TOOL_VERSION}/bin/node" -v

# echo "Compressing ${NAME} ${TOOL_VERSION} for ${ARCH}"
# brotli -Z "linux-${farch}-${mod}"

# cp "linux-${farch}-${mod}" "/cache/${TOOL_VERSION}"
# cp -f "${file}" "/cache/${NAME}-${TOOL_VERSION}-${ARCH}.tar.xz"
