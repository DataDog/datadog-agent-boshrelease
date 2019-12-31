#!/usr/bin/env bash

# Unless explicitly stated otherwise all files in this repository are licensed under the Apache 2.0 License.
# This product includes software developed at Datadog (https://www.datadoghq.com/). Copyright 2020 Datadog, Inc.

set -e # exit immediately if a simple command exits with a non-zero status
set -u # report the usage of uninitialized variables

# setup directories for everything
# separate these so that the setup shell scripts can be sourced by users easier
mkdir -p "$LOG_DIR" && chmod 775 "$LOG_DIR" && chown -R vcap "$LOG_DIR"
mkdir -p "$RUN_DIR" && chmod 775 "$RUN_DIR" && chown -R vcap "$RUN_DIR"
mkdir -p "$TMP_DIR" && chmod 775 "$TMP_DIR" && chown -R vcap "$TMP_DIR"
mkdir -p "$CONFD_DIR" && chmod 775 "$CONFD_DIR" && chown -R vcap "$CONFD_DIR"

set +e
set +u
