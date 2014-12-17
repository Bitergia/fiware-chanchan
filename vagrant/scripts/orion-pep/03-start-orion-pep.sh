#!/bin/bash

sudo cp ${SCRIPTS_PATH}/orion-pep/orion-pep.default /etc/default/orion-pep
sudo sed -i /etc/default/orion-pep \
     -e "s|^ORION_PEP_HOME=.*$|ORION_PEP_HOME=${HOME}/${ORION_PEP_HOME}|" \
     -e "s/^ORION_PEP_USER=.*$/ORION_PEP_USER='${ORION_PEP_USER}'/" \
     -e "s/^ORION_PEP_GROUP=.*$/ORION_PEP_GROUP='${ORION_PEP_USER}'/"
sudo cp ${SCRIPTS_PATH}/orion-pep/orion-pep.init /etc/init.d/orion-pep
sudo chmod +x /etc/init.d/orion-pep
sudo update-rc.d orion-pep defaults 90 90

sudo service orion-pep restart
