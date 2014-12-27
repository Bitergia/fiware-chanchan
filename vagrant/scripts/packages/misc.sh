#!/bin/bash

case "${DIST_TYPE}" in
    "debian")
	# install some extra utils
	apt-get -qy install tree ccze
	;;
    "redhat")
	yum -q -y install tree ccze man htop
	;;
    *)
	exit 1
	;;
esac
