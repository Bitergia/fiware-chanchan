#!/bin/bash

if [ -d "cantcoap" ]; then
    rm -fr "cantcoap"
fi

# clone repository
git clone https://github.com/staropram/cantcoap

# checkout a specific commit
cd cantcoap
git checkout 749e22376664dd3adae17492090e58882d3b28a7

# build
make

# install
sudo cp cantcoap.h dbg.h nethelper.h /usr/local/include
sudo cp libcantcoap.a /usr/local/lib
