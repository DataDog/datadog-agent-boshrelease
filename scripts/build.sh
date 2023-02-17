#!/usr/bin/env bash

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
IFS=$'\n\t'
set -euxo pipefail

RELEASE="datadog-agent"

./scripts/prepare.sh

if [ ! -f ./config/private.yml ]; then
  echo '{}' > ./config/private.yml
  echo "you need to set up your private.yml"
fi

VERSION_STRING=""

if [[ ! -z $VERSION ]]; then
  VERSION_STRING="--version=$VERSION"
fi

# setting up the local blobstore
cp config/final.yml config/final.yml.bk
cp config/final.yml.local config/final.yml

# Creating the release
bosh create-release --force --final --tarball=datadog-agent-release.tgz --name $RELEASE $VERSION_STRING

bosh upload-blobs

cp config/final.yml.bk config/final.yml
rm config/final.yml.bk
