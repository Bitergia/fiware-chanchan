#!/bin/bash

# install packages needed for the platform

if [ "${DIST_TYPE}" == "debian" ]; then
    # first update package list
    apt-get -qy update
fi

for f in $( ls packages/* ) ; do
    bash ${f}
done
