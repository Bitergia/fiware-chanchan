#!/bin/bash

if [ -d "fiware-orion" ]; then
    rm -rf "fiware-orion"
fi

# clone repository
git clone https://github.com/telefonicaid/fiware-orion

# build
cd fiware-orion/
if [ "${GIT_REV_ORION}" != "master" ]; then
    git checkout ${GIT_REV_ORION}
fi

INSTALL_DIR=${HOME} make install
