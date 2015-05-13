#!/bin/bash

# some procedures are different if we are inside a docker container,
# so we need to check it

# are we inside the matrix?

# When inside a docker container, the file /proc/1/cgroup contains the
# /docker/ path, so we do a first check with that

ret=1

if $( cat /proc/1/cgroup | grep -q -F "/docker/" ) ; then

    # also, there are two files, .dockerinit and .dockerenv on /, so check
    # for that too

    [ -e /.dockerinit -a -e /.dockerenv ] && ret=0
fi

exit $ret
