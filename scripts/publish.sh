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
if [ -z ${DRY_RUN+x} ]; then
  DRY_RUN="false"
fi
if [ -z ${BLOBS_BUCKET+x} ]; then
  echo "You must set a blobs bucket"
  exit 1
fi
if [ -z ${RELEASE_BUCKET+x} ]; then
  echo "You must set a release bucket"
  exit 1
fi
if [ -z ${REPO_BRANCH+x} ]; then
  echo "You must set a repo branch"
  exit 1
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
git checkout $REPO_BRANCH

cp $WORKING_DIR/config/final.yml.s3 $WORKING_DIR/config/final.yml
echo '{"blobstore": {"options": {"credentials_source": "env_or_profile"}}}' > $WORKING_DIR/config/private.yml

# run the prepare script
$WORKING_DIR/scripts/prepare.sh
bosh sync-blobs
# release a dev version of the agent to ensure the cache is warm
# (it's better to fail here than to fail when really attempting to release it)
bosh create-release --force --name "datadog-firehose-nozzle"

# if it's a dry run, then set the bucket to a local bucket
# we have to make sure the cache is warm first
if [ "$DRY_RUN" = "true" ]; then
  cp $WORKING_DIR/config/final.yml.local $WORKING_DIR/config/final.yml
  echo '{}' > $WORKING_DIR/config/private.yml
  BLOBS_BUCKET=""
else
  cp $WORKING_DIR/config/final.yml.s3 $WORKING_DIR/config/final.yml
fi

# finally, release the nozzle
$WORKING_DIR/scripts/create-release.sh

if [ ! "$DRY_RUN" = "true" ]; then
  # make sure we upload the blobs
  bosh upload-blobs
  s3cmd setacl "s3://${BLOBS_BUCKET}" --acl-public --recursive
  cp $WORKING_DIR/config/final.yml.s3.local $WORKING_DIR/config/final.yml
fi

if [ ! "$DRY_RUN" = "true" ]; then
  # git commit it and then push it to the repo
  git add $WORKING_DIR
  git commit -m "release datadog firehose nozzle $VERSION"
  git push

  # cache the blobs
  mkdir -p $WORKING_DIR/archive
  cp -R $WORKING_DIR/blobstore $WORKING_DIR/archive/blobstore
  cp $WORKING_DIR/datadog-firehose-nozzle-release.tgz $WORKING_DIR/archive/datadog-firehose-nozzle-release.tgz

  # Upload the archive to the release bucket
  aws s3 cp $WORKING_DIR/datadog-firehose-nozzle-release.tgz s3://$RELEASE_BUCKET/datadog-firehose-nozzle-release-$VERSION.tgz --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers full=id=3a6e02b08553fd157ae3fb918945dd1eaae5a1aa818940381ef07a430cf25732
  aws s3 cp $WORKING_DIR/datadog-firehose-nozzle-release.tgz s3://$RELEASE_BUCKET/datadog-firehose-nozzle-release-latest.tgz --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers full=id=3a6e02b08553fd157ae3fb918945dd1eaae5a1aa818940381ef07a430cf25732
fi
