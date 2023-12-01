#!/bin/bash

set -e

mkdir -p /build /cache

install-apt \
  g++ \
  make \
  ;
