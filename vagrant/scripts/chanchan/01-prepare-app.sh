#!/bin/bash

su - chanchan <<EOF
# clone app repository
git clone https://github.com/Bitergia/fiware-chanchan.git fiware-chanchan
cd ${CC_APP_PATH}

# install dependencies
npm install --loglevel warn
EOF
