#!/bin/bash

case "${DIST_TYPE}" in
    "debian")
	# default values
	DBROOTPW=${MYSQL_ROOTPW:-rootpw}
	MYSQL_UBUNTU_VERSION="5.5"

	# install debconf-utils for the debconf-set-selections command
	apt-get install -qy debconf-utils

	# preseed debconf to set the mysql root password
	cat << EOF | debconf-set-selections
mysql-server-${MYSQL_UBUNTU_VERSION} mysql-server/root_password password ${DBROOTPW}
mysql-server-${MYSQL_UBUNTU_VERSION} mysql-server/root_password_again password ${DBROOTPW}
mysql-server-${MYSQL_UBUNTU_VERSION} mysql-server/root_password seen true
mysql-server-${MYSQL_UBUNTU_VERSION} mysql-server/root_password_again seen true
EOF

	# install server
	apt-get install -qy mysql-server
	;;
    "redhat")
	yum -q -y install mysql mysql-server
	chkconfig mysqld on
	service mysqld restart
	sleep 2
	mysqladmin -u root password '${DBROOTPW}'
	;;
    *)
	exit 1
	;;
esac
