#!/bin/bash -e

die () {
    echo -e $1;
    exit $2;
}

is_sh () {
    value=$(ps -o args= -p "$$" | cut -f 1 -d " ")
    test "sh" = $value
    return
}

command_exists () {
    type "$1" &> /dev/null ;
}

if is_sh ; then
  die "\n Please don't invoke with sh, to uninstall use ./uninstall.sh"
fi

if [ "$EUID" -ne 0 ]; then
  die "\n Please run as sudo."  1
fi

if ! command_exists python3 ; then
    die "\n Sorry you need to have Python3 installed. Please install it and rerun this script."  1
fi

running_process=
if ps -Ao args | grep "[c]lai-run" &> /dev/null ; then
  running_process=$(ps -Ao args | grep "[c]lai-run" | head -1)
  pkill -f "${running_process}"
fi

eval "python3 uninstall.py"