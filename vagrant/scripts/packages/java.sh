#!/bin/bash

case "${DIST_TYPE}" in
    "debian")
	# install java
	apt-get install -qy openjdk-7-jdk

	# install maven
	apt-get install -qy maven
	;;
    "redhat")
	yum -q -y install java-1.7.0-openjdk java-1.7.0-openjdk-devel
	cd /tmp
	curl -OL http://www.eu.apache.org/dist/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz
	tar zxf apache-maven-3.2.5-bin.tar.gz -C /opt
	cd /opt
	ln -s apache-maven-3.2.5 maven
	mvn -version
	;;
    *)
	exit 1
	;;
esac
