#!/usr/bin/env bash

set -e
scripts/prepare.sh
set +e

VERSION_STRING=""
if [[ ! -z $VERSION ]]; then
  VERSION_STRING="--version=$VERSION"
fi

bosh create-release --force --final --tarball=datadog-firehose-nozzle-release.tgz $VERSION_STRING
