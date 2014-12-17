#!/bin/bash

# Copy the preconfigured config file directly
cp ${SCRIPTS_PATH}/cygnus/cygnus.conf ${HOME}/${APACHE_FLUME_HOME}/conf/cygnus.conf

sed -i ${HOME}/${APACHE_FLUME_HOME}/conf/cygnus.conf \
    -e "s/api_key = API_KEY/api_key = ${CKAN_API_KEY}/g"
