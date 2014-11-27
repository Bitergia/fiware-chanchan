#!/bin/bash

export SCRIPTS_PATH="/vagrant/scripts"
export UTILS_PATH="/vagrant/scripts/util"
cd ${SCRIPTS_PATH}

# load environment variables
source variables.sh

# load packages
bash packages.sh

# install IDM
bash install-idm.sh

# install Chanchan
bash install-chanchan.sh

# install Cygnus
bash install-cygnus.sh

# install Orion
bash install-orion.sh

# clean package cache
apt-get -qy clean
