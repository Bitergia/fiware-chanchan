#!/bin/bash

if [ -d "fiware-orion" ]; then
    rm -rf "fiware-orion"
fi

# clone repository
git clone https://github.com/telefonicaid/fiware-orion

# build
cd fiware-orion/
INSTALL_DIR=${HOME} make install
