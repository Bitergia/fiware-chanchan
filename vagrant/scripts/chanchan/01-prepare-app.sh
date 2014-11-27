#!/bin/bash

su - chanchan <<EOF
# clone app repository
git clone https://github.com/Bitergia/fiware-chanchan.git
cd fiware-chanchan/src

# install dependencies
npm install --loglevel warn
EOF
