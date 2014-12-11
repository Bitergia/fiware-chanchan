#!/bin/bash

sudo cp ${SCRIPTS_PATH}/cygnus/cygnus.default /etc/default/cygnus
sudo sed -i /etc/default/cygnus \
     -e "s|^CYGNUS_HOME=.*$|CYGNUS_HOME=${HOME}/${APACHE_FLUME_HOME}|" \
     -e "s/^CYGNUS_USER=.*$/CYGNUS_USER='${CYGNUS_USER}'/" \
     -e "s/^CYGNUS_GROUP=.*$/CYGNUS_GROUP='${CYGNUS_USER}'/"
sudo cp ${SCRIPTS_PATH}/cygnus/cygnus.init /etc/init.d/cygnus
sudo chmod +x /etc/init.d/cygnus
sudo update-rc.d cygnus defaults 90 90

sudo service cygnus restart
