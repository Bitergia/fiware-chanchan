#!/bin/bash

sudo cp ${SCRIPTS_PATH}/keypass/keypass.default /etc/default/keypass
sudo sed -i /etc/default/keypass \
     -e "s|^KEYPASS_HOME=.*$|KEYPASS_HOME=${HOME}/${KEYPASS_HOME}|" \
     -e "s/^KEYPASS_USER=.*$/KEYPASS_USER='${KEYPASS_USER}'/" \
     -e "s/^KEYPASS_GROUP=.*$/KEYPASS_GROUP='${KEYPASS_USER}'/"
sudo cp ${SCRIPTS_PATH}/keypass/keypass.init /etc/init.d/keypass
sudo chmod +x /etc/init.d/keypass
sudo update-rc.d keypass defaults 90 90

sudo service keypass restart
