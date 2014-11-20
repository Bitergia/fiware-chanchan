#!/bin/bash

if [[ $EUID -eq 0 ]]; then
  echo "Setup doesn't works properly if it used with root user." 1>&2
  exit 1
fi

sudo apt-get -y install apache2
