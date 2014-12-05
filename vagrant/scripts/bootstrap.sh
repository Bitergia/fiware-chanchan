#!/bin/bash

export SCRIPTS_PATH="/vagrant/scripts"
cd ${SCRIPTS_PATH}

# load environment variables
source variables.sh

# load packages
bash packages.sh

# install IDM
bash install-idm.sh

# provision IDM
bash idm-provision.sh

# install Chanchan
bash install-chanchan.sh

# install Cygnus
bash install-cygnus.sh

# install Orion
bash install-orion.sh

# install Orion PEP
bash install-orion-pep.sh

# install Keypass
bash install-keypass.sh

# clean package cache
apt-get -qy clean
