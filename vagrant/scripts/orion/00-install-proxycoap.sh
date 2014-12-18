#!/bin/bash

if [ -d "cantcoap" ]; then
    rm -fr "cantcoap"
fi

# clone repository
git clone https://github.com/staropram/cantcoap

# checkout a specific commit
cd cantcoap
if [ "${GIT_REV_ORION_PROXYCOAP}" != "master" ]; then
    git checkout ${GIT_REV_ORION_PROXYCOAP}
fi

# build
make

# install
sudo cp cantcoap.h dbg.h nethelper.h /usr/local/include
sudo cp libcantcoap.a /usr/local/lib
