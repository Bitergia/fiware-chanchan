#!/bin/bash

function _setup_init() {
    sudo cp ${SCRIPTS_PATH}/orion/orion.default ${DEFAULT}
    sudo sed -i ${DEFAULT} \
	 -e "s|^ORION_HOME=.*$|ORION_HOME=${HOME}|" \
	 -e "s/^ORION_USER=.*$/ORION_USER='${ORION_USER}'/" \
	 -e "s/^ORION_GROUP=.*$/ORION_GROUP='${ORION_USER}'/"
    sudo cp ${SCRIPTS_PATH}/orion/orion.init.${DIST_TYPE} /etc/init.d/orion
    sudo chmod +x /etc/init.d/orion
}

case "${DIST_TYPE}" in
    "debian")
	DEFAULT=/etc/default/orion
	_setup_init
	sudo update-rc.d orion defaults 90 90
	sudo service orion restart
	;;
    "redhat")
	DEFAULT=/etc/sysconfig/orion
	_setup_init
	sudo chkconfig orion on
	sudo service orion restart
	;;
    *)
	exit 1
	;;
esac

