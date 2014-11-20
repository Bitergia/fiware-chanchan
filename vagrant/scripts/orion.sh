#!/bin/bash

# Orion executables will me placed here
mkdir bin
# Build environment
sudo apt-get install -y libboost-all-dev libcurlpp-dev libmicrohttpd-dev mongodb-dev cmake  libcurl4-openssl-dev clang-3.5 libcunit1-dev mongodb g++
# Build proxyCoap
rm -rf cantcoap
git clone https://github.com/staropram/cantcoap
cd cantcoap
git checkout 749e22376664dd3adae17492090e58882d3b28a7
make
sudo cp cantcoap.h /usr/local/include
sudo cp dbg.h /usr/local/include
sudo cp nethelper.h /usr/local/include
sudo cp libcantcoap.a /usr/local/lib
cd ..
# Build Orion
rm -rf fiware-orion
git clone https://github.com/telefonicaid/fiware-orion
cd fiware-orion/
INSTALL_DIR=~ make install
cd ..
# Start Orion
killall contextBroker
~/bin/contextBroker &