#!/usr/bin/env bash

DEFAULT_NOZZLE_VERSION=2.4.0

NOZZLE_VERSION=${NOZZLE_VERSION:-$DEFAULT_NOZZLE_VERSION}

# Set NOZZLE_VERSION to `local` in order to use the current files on disk
# Useful for quick development iteration, no need to push to remote, just edit files on disk
if [ $NOZZLE_VERSION != "local" ]; then
  set -e
# Init and update the git submodule
  git submodule update --init --recursive
  # Checkout the version tag
  pushd src/datadog-firehose-nozzle
    git fetch --tags
    git checkout -f $NOZZLE_VERSION
    go mod vendor
  popd
  set +e
fi

rm -rf src/datadog-firehose-nozzle/pkg
