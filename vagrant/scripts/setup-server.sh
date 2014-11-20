#!/bin/bash

if [[ $EUID -eq 0 ]]; then
  echo "Setup doesn't works properly if it used with root user." 1>&2
  exit 1
fi

# Common setup for all components
sudo apt-get -y install apache2

# Cygnus connector configured to CKAN	
source ./cygnus.sh

# Orion Context Broker
source ./orion.sh

sudo apt-get -y clean