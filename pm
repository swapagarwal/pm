#!/usr/bin/env bash

set -e

LOG=${LOGFILE-$HOME/.pm.log}
CONFIG=${CONFIGFILE-$(pwd)/pm.config}

source $CONFIG

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
    expect "*?assword:"
    send "$CURRENT_PASSWORD\r"
    expect "*?assword:"
    send "$NEW_PASSWORD\r"
    expect "*?assword:"
    send "$NEW_PASSWORD\r"
    expect eof
END
}

function generateNewPassword
{
  new_pass=""
  arg_no=1
  args=${!scheme}
  for (( i=1; i<=args; i++ ));
  do
    def=$scheme"_"$i"_def"
    func=$scheme"_"$i"_func"
    if [[ "${!def}" == "STR" || "${!def}" == "NUM" ]]; then
      if [[ $# -lt $arg_no ]]; then
        echo "Too few parameters!"
        exit 2
      fi
      eval tmp=\${$arg_no}
      ((arg_no+=1))
      tmp=$(${!func} $tmp)
      # todo - separate STR/NUM
      # todo - chain functions?
      new_pass+=$tmp
    else
      new_pass+=${!def}
    fi
  done
  read -p "Enter username:" user
  read -p "Enter current password:" -s curr_pass
  changePassword $user $curr_pass $new_pass
}

function checkScheme
{
  scheme=$1
  if [ -z "${!scheme}" ]; then
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
  test | t)
    changePassword "${@:2}"
    ;;
  help | h | *)
    echo "usage: pm [command]"
    echo
    echo "Available commands:"
    echo "  scheme [schemeName] [arguments(STR/NUM)]..."
    echo "  test [username] [current password] [new password]"
    echo "  help (default)"
    ;;
esac
