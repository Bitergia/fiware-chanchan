#!/bin/bash

# some systems may forbid ssh login attempts if the user does not
# have a password, so we generate a random one to avoid this
# problem.

username=$1
length=$2

script_name=$( basename $0 )


function usage () {
    echo "Usage: $scriptname <username> [length]"
    exit 1
}

if [ $# -eq 0 ]; then
    usage
fi

if [ "x${username}" = "x" ]; then
    echo "$scriptname: No username supplied"
    usage
fi

cat /dev/urandom | tr -dc 'a-zA-Z0-9!@#$%^&*()_+?><~\`;' | fold -w ${length:-32} | head -n 1 | passwd --stdin ${username}
