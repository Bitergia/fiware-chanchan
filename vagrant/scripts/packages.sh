#!/bin/bash

# install packages needed for the platform

# first update package list
apt-get -qy update

for f in $( ls packages/* ) ; do
    bash ${f}
done
