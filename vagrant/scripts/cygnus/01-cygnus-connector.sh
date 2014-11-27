#!/bin/bash

# remove old connectors
if [ -d "fiware-connectors" ]; then
    rm -rf "fiware-connectors"
fi

# get fiware-connectors
git clone https://github.com/telefonicaid/fiware-connectors.git fiware-connectors

# compile connectors
cd fiware-connectors/flume
mvn clean compile exec:exec assembly:single
cd ../..

# install connectors
cp ${HOME}/fiware-connectors/flume/target/cygnus-*-jar-with-dependencies.jar ${HOME}/${APACHE_FLUME_HOME}/plugins.d/cygnus/lib
cp ${HOME}/.m2/repository/com/googlecode/json-simple/json-simple/1.1/json-simple-1.1.jar ${HOME}/${APACHE_FLUME_HOME}/plugins.d/cygnus/libext/
