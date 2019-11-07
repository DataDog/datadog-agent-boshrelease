#!/usr/bin/env bash

# only install glide if it is not installed
type glide >/dev/null 2>&1 || (echo "installing Glide" && curl https://glide.sh/get | sh )

export GOPATH="$(pwd)/src/datadog-firehose-nozzle/:$GOPATH"

DEFAULT_NOZZLE_VERSION=1.3.0

NOZZLE_VERSION=${NOZZLE_VERSION:-$DEFAULT_NOZZLE_VERSION}

# Set NOZZLE_VERSION to `local` in order to use the current files on disk
# Useful for quick development iteration, no need to push to remote, just edit files on disk
if [ $NOZZLE_VERSION != "local" ]; then
  set -e
# Init and update the git submodule
  git submodule update --init --recursive
  # Checkout the version tag
  pushd src/datadog-firehose-nozzle/src/github.com/DataDog/datadog-firehose-nozzle
    git fetch --tags
    git checkout -f $NOZZLE_VERSION
    glide install
  popd
  set +e
fi

rm -rf src/datadog-firehose-nozzle/pkg
