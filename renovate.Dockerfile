#-------------------------
# renovate rebuild trigger
#-------------------------

# makes lint happy
FROM scratch

# renovate: datasource=npm depName=re2
ENV NODE_RE2_VERSION=1.20.9
