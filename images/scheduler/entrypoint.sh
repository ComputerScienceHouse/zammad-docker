#!/bin/bash
# Zammad Scheduler Entrypoint
set -e

if [ -n "$ZAMMAD_HOSTNAME" ]; then
  until (echo > "/dev/tcp/${ZAMMAD_HOSTNAME}/3000") &> /dev/null; do
    echo "--> Waiting for Zammad to start..."
    sleep 5
  done

  echo "--> Starting scheduler..."
  exec bundle exec script/scheduler.rb run
else
  echo "ERROR: You must set the ZAMMAD_HOSTNAME environment variable to the hostname of the main Zammad application"
  exit 1
fi
