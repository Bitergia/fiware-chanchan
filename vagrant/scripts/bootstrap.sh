#!/bin/bash

# check distribution
DIST=""
if [ -f "/etc/redhat-release" ]; then
    grep -q "CentOS release 6.5" "/etc/redhat-release" && DIST="centos6.5"
else
    if [ -f "/etc/lsb-release" ]; then
	grep -q "Ubuntu 14.04" "/etc/lsb-release" && DIST="ubuntu14.04"
    fi
fi

case ${DIST} in
    "centos6.5")
	echo "CentOS 6.5 provisioning is not supported yet"
	DIST_TYPE="redhat"
	;;
    "ubuntu14.04")
	echo "Provisioning for Ubuntu 14.04"
	DIST_TYPE="debian"
	;;
    *)
	echo "Unsupported distribution"
	exit 1
	;;
esac
export DIST DIST_TYPE

# allow running the provision scripts on non-vagrant environments
_vagrant_user="vagrant"
getent passwd ${_vagrant_user} 2>&1 >/dev/null
_status=$?
case ${_status} in
    0)
	# running on vagrant
	SCRIPTS_PATH="/vagrant/scripts"
	# when using vagrant, the public IP will be on eth1
	IFACE="eth1"
	;;
    2)
	# vagrant user not found
	SC_PATH=$( cd $( dirname $0 ) 2>&1 >/dev/null && pwd )
	mkdir -p /opt/vagrant && cp -r ${SC_PATH} /opt/vagrant
	SCRIPTS_PATH="/opt/vagrant/scripts"
	# use the default interface for the public IP
	IFACE="eth0"
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

if [ "${DIST_TYPE}" != "debian" ]; then
    exit 1
fi

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
