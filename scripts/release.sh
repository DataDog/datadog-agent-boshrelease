#!/bin/bash -l

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
IFS=$'\n\t'
set -euxo pipefail

# This script is to release the agent bosh release from Datadog's internal infrastructure.
# It won't work for anyone else
if [[ -z ${VERSION+x} ]]; then
  echo "You must set a version"
  exit 1
fi

# Make sure variables are set
if [ -z ${PRODUCTION+x} ]; then
  PRODUCTION="false"
fi
if [ -z ${STAGING+x} ]; then
  STAGING="false"
fi
if [ -z ${DRY_RUN+x} ]; then
  DRY_RUN="false"
fi
if [ -z ${RELEASE_BUCKET+x} ]; then
  RELEASE_BUCKET="false"
fi
if [ -z ${REPO_BRANCH+x} ]; then
  REPO_BRANCH="greg/test"
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKING_DIR="$DIR/.."

mkdir -p $WORKING_DIR/blobstore

# if bosh isn't on the docker image, download it
if [ ! -f "/usr/local/bin/bosh" ]; then
  mkdir -p $WORKING_DIR/bin
  curl -sSL -o $WORKING_DIR/bin/bosh https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.48-linux-amd64
  chmod +x $WORKING_DIR/bin/bosh
  export PATH="$WORKING_DIR/bin:$PATH"
fi

git config --global push.default simple
# git config --global user.name "Datadog"
# git config --global user.email "dev@datadoghq.com"
git checkout $REPO_BRANCH

# if it's production set the bucket to production
if [ "$PRODUCTION" = "true" ]; then
  cp $WORKING_DIR/config/final.yml.s3 $WORKING_DIR/config/final.yml
  BUCKET_NAME="public-datadog-agent-boshrelease"
  echo '{"blobstore": {"options": {"credentials_source": "env_or_profile"}}}' > $WORKING_DIR/config/private.yml
fi

# upload to the staging buckets if it's a staging release
if [ "$STAGING" = "true" ]; then
 cp $WORKING_DIR/config/final.yml.s3.staging $WORKING_DIR/config/final.yml
 echo '{"blobstore": {"options": {"credentials_source": "env_or_profile"}}}' > $WORKING_DIR/config/private.yml

 BUCKET_NAME="public-datadog-agent-boshrelease-staging"
 # For staging we should make sure everything is available in the staging bucket
 # aws s3 cp s3://public-datadog-agent-boshrelease/ s3://public-datadog-agent-boshrelease-staging/ --recursive --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers full=id=3a6e02b08553fd157ae3fb918945dd1eaae5a1aa818940381ef07a430cf25732
fi

# make sure we're in the right directory
cd $WORKING_DIR
if [ ! -f $WORKING_DIR/config/private.yml ]; then
  echo '{}' > $WORKING_DIR/config/private.yml
fi

# run the prepare script
./prepare
bosh sync-blobs
# release a dev version of the agent to ensure the cache is warm
# (it's better to fail here than to fail when really attempting to release it)
bosh create-release --force --name "datadog-agent"

# if it's a try run, then set the bucket to a local bucket
# we have to make sure the cache is warm first
if [ "$DRY_RUN" = "true" ]; then
  cp $WORKING_DIR/config/final.yml.s3.local $WORKING_DIR/config/final.yml
  echo '{}' > $WORKING_DIR/config/private.yml
  BUCKET_NAME=""
fi

# finally, release the agent
./release
# make sure we upload the blobs
bosh upload-blobs

# git commit it and then push it to the repo
git add .
git commit -m "releases datadog agent $VERSION"
git push

# cache the blobs
mkdir -p ./archive
cp -R $WORKING_DIR/blobstore archive/blobstore
cp $WORKING_DIR/datadog-agent-release.tgz archive/datadog-agent-release.tgz

if [ "$RELEASE_BUCKET" -a "$RELEASE_BUCKET" != "false" ]; then
  if [ "$PRODUCTION" = "true" ]; then
    # the production release bucket is cloudfoundry.datadoghq.com/datadog-agent
    aws s3 cp datadog-agent-release.tgz s3://$RELEASE_BUCKET/datadog-agent-boshrelease-$VERSION.tgz --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers full=id=3a6e02b08553fd157ae3fb918945dd1eaae5a1aa818940381ef07a430cf25732

    aws s3 cp datadog-agent-release.tgz s3://$RELEASE_BUCKET/datadog-agent-boshrelease-latest.tgz --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers full=id=3a6e02b08553fd157ae3fb918945dd1eaae5a1aa818940381ef07a430cf25732
  fi
fi
