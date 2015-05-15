#!/usr/bin/env bash

set -e

LOG=${LOGFILE-$HOME/.pm.log}

# Define your password schemes here
# STR and NUM will be calculated according to input
myPassword=( "pass" "STR" "NUM" "word" )

# Functions used to generate the new password
# Feel free to add your own
function toUpper
{
  str=$1
  echo "$str" | tr '[:lower:]' '[:upper:]'
}

function toLower
{
  str=$1
  echo "$str" | tr '[:upper:]' '[:lower:]'
}

function myFunction
{
  str=$1
  echo $(($str*2+1))
}

# The main function
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

function generateNewPassword
{
  new_pass=""
  arg_no=1
  for i in "${str[@]}"
  do
    if [ "$i" == "STR" ]; then
      eval tmp=\${$arg_no}
      ((arg_no+=1))
      # todo - apply functions (maybe, chain?)
      new_pass+=$tmp
    elif [ "$i" == "NUM" ]; then
      eval tmp=\${$arg_no}
      ((arg_no+=1))
      # todo - apply functions (maybe, chain?)
      new_pass+=$tmp
    else
      new_pass+=$i
    fi
  done
  read -p "Enter username:" user
  read -p "Enter current password:" -s curr_pass
  changePassword $user $curr_pass $new_pass
}

function checkScheme
{
  eval str=("\${$1[@]}")
  if [ -z "${str}" ]; then
    echo "$1 doesn't exist"
    exit 1
  fi
  # todo - verify arguments match the scheme
  generateNewPassword "${@:2}"
}

case "$1" in
  scheme | s)
    checkScheme "${@:2}"
    ;;
  *)
    changePassword "$@"
    ;;
esac
