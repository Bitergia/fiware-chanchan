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

_do_clock_check=0
case ${DIST} in
    "centos6.5")
	echo "(Partial) Provisioning for CentOS 6.5"
	DIST_TYPE="redhat"
	_do_clock_check=1
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
	if [ ${_do_clock_check} -eq 1 ]; then
	    ${SCRIPTS_PATH}/util/fix-centos-clock.sh
	    ret=$?
	    case $ret in
		0)
		    # just added fix, reboot needed
		    echo "#########################################################"
		    echo "#"
		    echo "# Added clocksource_failover=acpi_pm to kernel parameters"
		    echo "# This change requires a reboot to take effect.  Please,"
		    echo "# issue the following command to reboot and continue"
		    echo "# provisioning:"
		    echo "#"
		    echo "# vagrant reload --provision centos"
		    echo "#"
		    echo "#########################################################"
		    exit 0
		    ;;
		1)
		    # fix failed
		    echo "Clock fix failed"
		    exit 1
		    ;;
		2)
		    # fix added and rebooted, continue
		    echo "Clock fix in place, continuing"
		    ;;
		*)
		    exit 1
	    esac
	fi
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

# provision IDM app
bash idm-provision-app.sh

# install Chanchan
bash install-chanchan.sh

# install Keypass
bash install-keypass.sh

# provision IDM roles
bash idm-provision-roles.sh

# install Orion
bash install-orion.sh

# install Orion PEP
bash install-orion-pep.sh

if [ "${DIST_TYPE}" != "debian" ]; then
    exit 1
fi

# install Cygnus
bash install-cygnus.sh

# clean package cache
apt-get -qy clean
