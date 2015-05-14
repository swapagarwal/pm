#!/usr/bin/env bash

set -e

LOG=${LOGFILE-$HOME/.pm.log}

function changePassword
{
  USER_NAME=$1
  CURRENT_PASSWORD=$2
  NEW_PASSWORD=$3
  echo "Changing password of $USER_NAME from $CURRENT_PASSWORD to $NEW_PASSWORD" >> "$LOG"
  expect <<END
    spawn passwd $USER_NAME
    expect "password:"
    send "$CURRENT_PASSWORD\r"
    expect "password:"
    send "$NEW_PASSWORD\r"
    expect "password:"
    send "$NEW_PASSWORD\r"
    expect eof
END
}

case "$1" in
  *)
    changePassword "$@"
    ;;
esac
