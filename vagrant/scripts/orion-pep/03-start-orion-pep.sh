#!/bin/bash

function _setup_init() {
    sudo cp ${SCRIPTS_PATH}/orion-pep/orion-pep.default ${DEFAULT}
    sudo sed -i ${DEFAULT} \
	 -e "s|^ORION_PEP_HOME=.*$|ORION_PEP_HOME=${HOME}/${ORION_PEP_HOME}|" \
	 -e "s/^ORION_PEP_USER=.*$/ORION_PEP_USER='${ORION_PEP_USER}'/" \
	 -e "s/^ORION_PEP_GROUP=.*$/ORION_PEP_GROUP='${ORION_PEP_USER}'/"
    sudo cp ${SCRIPTS_PATH}/orion-pep/orion-pep.init.${DIST_TYPE} /etc/init.d/orion-pep
    sudo chmod +x /etc/init.d/orion-pep
}

case "${DIST_TYPE}" in
    "debian")
	DEFAULT=/etc/default/orion-pep
	_setup_init
	sudo update-rc.d orion-pep defaults 90 90
	sudo service orion-pep restart
	;;
    "redhat")
	DEFAULT=/etc/sysconfig/orion-pep
	_setup_init
	sudo chkconfig orion-pep on
	sudo service orion-pep restart
	;;
    *)
	exit 1
	;;
esac

