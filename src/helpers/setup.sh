#!/usr/bin/env bash

# Unless explicitly stated otherwise all files in this repository are licensed under the Apache 2.0 License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2017-Present Datadog, Inc.

set -e # exit immediately if a simple command exits with a non-zero status
set -u # report the usage of uninitialized variables

export NAME=${1:-$JOB_NAME}
export HOME=${HOME:-/home/vcap}
export JOB_DIR="/var/vcap/jobs/$NAME"
export PACKAGES="$JOB_DIR/packages"

export COMPONENT=${2:-$NAME}

# Setup the PATH
export PATH="$PACKAGES/$NAME/checks.d:$PACKAGES/$NAME/bin:$PACKAGES/$NAME/embedded/bin:$PATH"

# Automatically detected the available python version
DETECTED_PYTHON=$(ls "$PACKAGES/$NAME/embedded/lib" | grep '^python3\.[0-9]*$' | head -n1)

# Const for the path to the embedded py3 directory
EMBEDDED_PATH="embedded/lib/$DETECTED_PYTHON"

# Setup the LD_LIBRARY_PATH
LD_LIBRARY_PATH=${LD_LIBRARY_PATH:-''}
LD_LIBRARY_PATH="$PACKAGES/$NAME/embedded/lib:$LD_LIBRARY_PATH"
LD_LIBRARY_PATH="$PACKAGES/$NAME/$EMBEDDED_PATH/lib-dynload:$LD_LIBRARY_PATH"
LD_LIBRARY_PATH="$PACKAGES/$NAME/$EMBEDDED_PATH/site-packages:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH

# Python modules
PYTHONPATH=${PYTHONPATH:-''}
PYTHONPATH="$PACKAGES/$NAME/$EMBEDDED_PATH:$PYTHONPATH"
PYTHONPATH="$PACKAGES/$NAME/$EMBEDDED_PATH/site-packages:$PYTHONPATH"
PYTHONPATH="$PACKAGES/$NAME/checks.d:$PYTHONPATH"
PYTHONPATH="$PACKAGES/$NAME/agent/checks/libs:$PYTHONPATH"
PYTHONPATH="$PACKAGES/$NAME/agent:$PYTHONPATH"
PYTHONPATH="$PACKAGES/$NAME/$EMBEDDED_PATH/lib-dynload:$PYTHONPATH"
export PYTHONPATH="$PACKAGES/$NAME/bin/agent/dist:$PYTHONPATH"

# export directories
export LOG_DIR="/var/vcap/sys/log/$NAME"
export RUN_DIR="/var/vcap/sys/run/$NAME"
export PIDFILE="$RUN_DIR/$COMPONENT.pid"
export TMP_DIR="/var/vcap/sys/tmp/$NAME"
export TMPDIR=$TMP_DIR
export CONFD_DIR="$JOB_DIR/config/conf.d"

export LANG=POSIX

KNOWN_DISTRIBUTION="(Debian|Ubuntu|RedHat|CentOS|openSUSE|Amazon|Arista|SUSE)"
DISTRIBUTION=$(lsb_release -d 2>/dev/null | grep -Eo $KNOWN_DISTRIBUTION  || grep -Eo $KNOWN_DISTRIBUTION /etc/issue 2>/dev/null || grep -Eo $KNOWN_DISTRIBUTION /etc/Eos-release 2>/dev/null || uname -s)

# Make python checks use the system CA store
if [ -f /etc/redhat-release -o "$DISTRIBUTION" == "RedHat" -o "$DISTRIBUTION" == "CentOS" -o "$DISTRIBUTION" == "Amazon" ]; then
    export REQUESTS_CA_BUNDLE="/etc/pki/tls/certs/ca-bundle.crt"
else
    export REQUESTS_CA_BUNDLE="/etc/ssl/certs/ca-certificates.crt"
fi

set +e
set +u
