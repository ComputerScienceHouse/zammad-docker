#!/bin/bash
# Zammad Websockets Server Entrypoint

if [ -n "$ZAMMAD_HOSTNAME" ]; then
  until (echo > "/dev/tcp/${ZAMMAD_HOSTNAME}/3000") &> /dev/null; do
    echo "--> Waiting for Zammad to start..."
    sleep 5
  done

  echo "--> Starting websockets server..."
  exec bundle exec script/websocket-server.rb -b 0.0.0.0 start
else
  echo "ERROR: You must set the ZAMMAD_HOSTNAME environment variable to the hostname of the main Zammad application"
  exit 1
fi
