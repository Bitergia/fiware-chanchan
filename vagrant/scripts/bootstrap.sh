#!/bin/bash

# allow running the provision scripts on non-vagrant environments
_vagrant_user="vagrant"
getent passwd ${_vagrant_user} 2>&1 >/dev/null
_status=$?
case ${_status} in
    0)
	# running on vagrant
	SCRIPTS_PATH="/vargrant/scripts"
	;;
    2)
	# vagrant user not found
	SC_PATH=$( cd $( dirname $0 ) 2>&1 >/dev/null && pwd )
	mkdir -p /opt/vagrant && cp -r ${SC_PATH} /opt/vagrant
	SCRIPTS_PATH="/opt/vagrant/scripts"
	;;
    *)
	# it should not get here
	echo "getent failed with error: ${_status}"
	exit 1
	;;
esac

cd ${SCRIPTS_PATH}

# load environment variables
source variables.sh

# swap: 512 MB default
bash swap.sh

# load packages
bash packages.sh

# install IDM
bash install-idm.sh

# provision IDM
bash idm-provision.sh

# install Chanchan
bash install-chanchan.sh

# install Orion
bash install-orion.sh

# install Orion PEP
bash install-orion-pep.sh

# install Cygnus
bash install-cygnus.sh

# install Keypass
bash install-keypass.sh

# clean package cache
apt-get -qy clean
