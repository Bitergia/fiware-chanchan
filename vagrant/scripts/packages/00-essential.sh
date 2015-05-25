#!/bin/bash

case "${DIST_TYPE}" in
    "debian")
	# install bash
	apt-get install -qy bash
	;;
    "redhat")
	yum -q -y install bash which
	# we'll be installing later some packages from EPEL, so add the repository now
	cd /tmp
	curl -OL http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
	yum localinstall -y epel-release-6-8.noarch.rpm
	;;
    *)
	exit 1
	;;
esac
