#!/bin/bash

case "${DIST_TYPE}" in
    "debian")
	# install java
	apt-get install -qy openjdk-7-jdk

	# install maven
	apt-get install -qy maven
	;;
    "redhat")
	;;
    *)
	exit 1
	;;
fi
