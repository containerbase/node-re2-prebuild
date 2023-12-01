FROM ghcr.io/containerbase/base:9.26.0@sha256:d64249bced930342154688a79d0bc537423c2e5918c476361e0e22f5fd734c83

# renovate: datasource=github-releases packageName=containerbase/python-prebuild
RUN install-tool python 3.12.0

# missing since python v3.12.0
RUN pip install setuptools

ENTRYPOINT [ "dumb-init", "--", "builder.sh" ]

COPY bin /usr/local/bin

RUN install-builder.sh

WORKDIR /build

# renovate: datasource=npm depName=re2
ENV NODE_RE2_VERSION=1.20.9
