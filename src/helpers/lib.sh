#!/usr/bin/env bash
#
# Helper functions used by ctl scripts
#
set -e # exit immediately if a simple command exits with a non-zero status
set -u # report the usage of uninitialized variables

# Log some info to the Monit Log file
function log {
  local message=${1}
  local timestamp=`date +%y:%m:%d-%H:%M:%S`
  printf "${timestamp} :: ${message}\n" >> "/var/vcap/sys/log/${NAME}/${COMPONENT:-$NAME}_script.log"
}

# Print a message
function printf_log {
  local message=${1}
  local timestamp=`date +%y:%m:%d-%H:%M:%S`
  printf "${timestamp} :: ${message}\n" | tee -a "/var/vcap/sys/log/${NAME}/${COMPONENT:-$NAME}_script.log"
}

# Print a message without \n at the end
function echon_log {
  local message=${1}
  local timestamp=`date +%y:%m:%d-%H:%M:%S`
  printf "${timestamp} :: ${message} \n" | tee -a "/var/vcap/sys/log/${NAME}/${COMPONENT:-$NAME}_script.log"
}

# Print a message and exit with error
function die {
  printf_log "$@"
  exit 1
}

# If loaded within monit ctl scripts then pipe output
# If loaded from 'source ../utils.sh' then normal STDOUT
function redirect_output {
  mkdir -p /var/vcap/sys/log/monit
  exec 1>> /var/vcap/sys/log/monit/$NAME.log
  exec 2>> /var/vcap/sys/log/monit/$NAME.err.log
}


function pid_guard {
  local pidfile=$1
  local name=$2

  if [ -f "$pidfile" ]; then
    pid=$(head -1 "$pidfile")
    if [ -n "$pid" ] && [ -e /proc/$pid ]; then
      die "$name is already running, please stop it first"
    fi
    printf_log "Removing stale pidfile ..."
    rm $pidfile
  fi
}


function wait_pid {
  local pid=$1
  local try_kill=$2
  local timeout=${3:-0}
  local force=${4:-0}
  local countdown=$(( $timeout * 10 ))

  if [ -e /proc/$pid ]; then
    if [ "$try_kill" = "1" ]; then
      echon_log "Killing $pidfile: $pid "
      kill $pid
    fi
    while [ -e /proc/$pid ]; do
      sleep 0.1
      [ "$countdown" != '0' -a $(( $countdown % 10 )) = '0' ] && echo -n .
      if [ $timeout -gt 0 ]; then
        if [ $countdown -eq 0 ]; then
          if [ "$force" = "1" ]; then
            echo
            printf_log "Kill timed out, using kill -9 on $pid ..."
            kill -9 $pid
            sleep 0.5
          fi
          break
        else
          countdown=$(( $countdown - 1 ))
        fi
      fi
    done
    if [ -e /proc/$pid ]; then
      printf_log "Timed Out"
    else
      printf_log "Stopped"
    fi
  else
    printf_log "Process $pid is not running"
  fi
}


function wait_pidfile {
  local pidfile=$1
  local try_kill=$2
  local timeout=${3:-0}
  local force=${4:-0}
  local countdown=$(( $timeout * 10 ))

  if [ -f "$pidfile" ]; then
    pid=$(head -1 "$pidfile")
    if [ -z "$pid" ]; then
      die "Unable to get pid from $pidfile"
    fi
    wait_pid $pid $try_kill $timeout $force
    rm -f $pidfile
  else
    printf_log "Pidfile $pidfile doesn't exist"
  fi
}


function kill_and_wait {
  local pidfile=$1
  # Monit default timeout for start/stop is 30s
  # Append 'with timeout {n} seconds' to monit start/stop program configs
  local timeout=${2:-25}
  local force=${3:-1}

  if [ -f "${pidfile}" ]; then
    wait_pidfile $pidfile 1 $timeout $force
  else
    # TODO assume $1 is something to grep from 'ps ax'
    pid="$(ps auwwx | grep "$1" | awk '{print $2}')"
    wait_pid $pid 1 $timeout $force
  fi
}

function find_pid_kill_and_wait {
  local find_command=$1
  local pid=$(find_pid)
  local timeout=${2:-25}
  local force=${3:-1}

  wait_pid $pid 1 $timeout $force
}

function find_pid {
  local find_command=$1
  local pid=$(pgrep -f $find_command)

  echo $pid
}


function check_nfs_mount {
  local opts=$1
  local exports=$2
  local mount_point=$3

  if grep -qs $mount_point /proc/mounts; then
    printf_log "Found NFS mount $mount_point"
  else
    printf_log "Mounting NFS ..."
    mount $opts $exports $mount_point
    if [ $? != 0 ]; then
      die "Cannot mount NFS from $exports to $mount_point, exiting ..."
    fi
  fi
}
