#!/bin/bash

case "${DIST_TYPE}" in
    "debian")
	# install bash
	apt-get install -qy bash
	;;
    "redhat")
	yum -q -y install bash
	;;
    *)
	exit 1
	;;
esac
