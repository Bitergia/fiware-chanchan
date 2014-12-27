#!/bin/bash

function _setup_init () {
    sudo cp ${SCRIPTS_PATH}/cygnus/cygnus.default ${DEFAULT}
    sudo sed -i ${DEFAULT} \
	 -e "s|^CYGNUS_HOME=.*$|CYGNUS_HOME=${HOME}/${APACHE_FLUME_HOME}|" \
	 -e "s/^CYGNUS_USER=.*$/CYGNUS_USER='${CYGNUS_USER}'/" \
	 -e "s/^CYGNUS_GROUP=.*$/CYGNUS_GROUP='${CYGNUS_USER}'/"
    sudo cp ${SCRIPTS_PATH}/cygnus/cygnus.init.${DIST_TYPE} /etc/init.d/cygnus
    sudo chmod +x /etc/init.d/cygnus
}

case "${DIST_TYPE}" in
    "debian")
	DEFAULT=/etc/default/cygnus
	_setup_init
	sudo update-rc.d cygnus defaults 90 90
	sudo service cygnus restart
	;;
    "redhat")
	DEFAULT=/etc/sysconfig/cygnus
	_setup_init
	sudo chkconfig cygnus on
	sudo service cygnus restart
	;;
    *)
	exit 1
	;;
esac

