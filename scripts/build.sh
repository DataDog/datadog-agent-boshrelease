#!/bin/bash

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
IFS=$'\n\t'
set -euxo pipefail

if [ ! -f ./config/private.yml ]; then
  echo '{}' > ./config/private.yml
  echo "you need to set up your private.yml"
fi

# Creating the release
bosh create-release --force --final --tarball=datadog-agent-release.tgz --name datadog-agent --version "$VERSION"
