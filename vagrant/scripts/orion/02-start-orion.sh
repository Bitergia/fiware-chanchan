#!/bin/bash

sudo cp ${SCRIPTS_PATH}/orion/orion.default /etc/default/orion
sudo sed -i /etc/default/orion \
     -e "s|^ORION_HOME=.*$|ORION_HOME=${HOME}|" \
     -e "s/^ORION_USER=.*$/ORION_USER='${ORION_USER}'/" \
     -e "s/^ORION_GROUP=.*$/ORION_GROUP='${ORION_USER}'/"
sudo cp ${SCRIPTS_PATH}/orion/orion.init /etc/init.d/orion
sudo chmod +x /etc/init.d/orion
sudo update-rc.d orion defaults 90 90

sudo service orion restart
