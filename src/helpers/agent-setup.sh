#!/usr/bin/env bash

# Unless explicitly stated otherwise all files in this repository are licensed under the Apache 2.0 License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2017-Present Datadog, Inc.

set -e # exit immediately if a simple command exits with a non-zero status
set -u # report the usage of uninitialized variables

# Some tasks that need to be done before the agent is started


function ensure_agent_ownership {
  # make sure the agent owns the config directory
  chown -R vcap:vcap "$JOB_DIR/config/"
  # make sure the agent owns its own directory
  chown -R vcap:vcap "$JOB_DIR/packages/dd-agent/"
  # make sure that root owns the system probe config
  chown root:root "$JOB_DIR/config/system-probe.yaml" && chmod 0644 "$JOB_DIR/config/system-probe.yaml"
  # make sure that root owns system probe binary and ebpf files
  chown root:root "$JOB_DIR/packages/dd-agent/embedded/bin/system-probe"
  chown root:root -R "$JOB_DIR/packages/dd-agent/embedded/share/system-probe/ebpf"

  # make sure that dd-agent user exists as an alias of vcap
  if ! id dd-agent &>/dev/null; then
    sudo useradd -N -r -s /usr/sbin/nologin -u $(id -u vcap) -g vcap -o dd-agent
  fi
}


function stop_agent {
  local agent_command=$1
  (
      {
          exec chpst -v -u vcap:vcap "$DD_AGENT" stop -c $JOB_DIR/config/
      } >>$LOG_DIR/$COMPONENT.stdout.log \
      2>>$LOG_DIR/$COMPONENT.stderr.log
  ) || true
  find_pid_kill_and_wait $1 || true
}


function check_if_running_and_kill {
  local agent_command="$1"
  local do_not_wait="$2"
  local pid=$(find_pid $agent_command)
  if [ -n "$pid" ]; then
    printf_log "The Agent is running, stopping it"
    if [ -n "$do_not_wait" ]; then
      kill -9 "$pid"
    else
      stop_agent $agent_command
    fi
  fi
}

set +e
set +u
