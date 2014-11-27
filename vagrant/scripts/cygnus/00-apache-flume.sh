#!/bin/bash

if [ -d "${APACHE_FLUME_HOME}" ]; then
    rm -rf "${APACHE_FLUME_HOME}"
fi

VERSION="1.4.0"
TGZ="apache-flume-${VERSION}-bin.tar.gz"
UNPACKED="apache-flume-${VERSION}-bin"
URL="http://archive.apache.org/dist/flume/${VERSION}/${TGZ}"

# download flume
curl --location --insecure --silent --show-error "${URL}"

# unpack tgz
tar zxf "${TGZ}"

# move to destination
mv "${UNPACKED}" "${APACHE_FLUME_HOME}"

# add some needed directories
mkdir -p "${APACHE_FLUME_HOME}/plugins.d/cygnus"
mkdir -p "${APACHE_FLUME_HOME}/plugins.d/cygnus/lib"
mkdir -p "${APACHE_FLUME_HOME}/plugins.d/cygnus/libext"
