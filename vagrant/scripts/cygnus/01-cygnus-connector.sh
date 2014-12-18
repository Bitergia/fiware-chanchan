#!/bin/bash

# remove old connectors
if [ -d "${CYGNUS_CONNECTORS_HOME}" ]; then
    rm -rf "${CYGNUS_CONNECTORS_HOME}"
fi

# get fiware-connectors
git clone https://github.com/telefonicaid/fiware-connectors.git ${CYGNUS_CONNECTORS_HOME}

cd ${HOME}/${CYGNUS_CONNECTORS_HOME}
if [ "${GIT_REV_CYGNUS}" != "master" ]; then
    git checkout ${GIT_REV_CYGNUS}
fi

# compile connectors
cd ${HOME}/${CYGNUS_CONNECTORS_HOME}/flume
mvn clean compile exec:exec assembly:single
cd ../..

# install connectors
cp ${HOME}/${CYGNUS_CONNECTORS_HOME}/flume/target/cygnus-*-jar-with-dependencies.jar ${HOME}/${APACHE_FLUME_HOME}/plugins.d/cygnus/lib
cp ${HOME}/.m2/repository/com/googlecode/json-simple/json-simple/1.1/json-simple-1.1.jar ${HOME}/${APACHE_FLUME_HOME}/plugins.d/cygnus/libext/
