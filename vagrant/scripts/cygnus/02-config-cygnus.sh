#!/bin/bash

# copy template config
cp ${HOME}/fiware-connectors/flume/conf/cygnus.conf.template ${HOME}/${APACHE_FLUME_HOME}/conf/cygnus.conf

# edit config
sed -i ${HOME}/${APACHE_FLUME_HOME}/conf/cygnus.conf \
    -e "s/cygnusagent.sinks = hdfs-sink mysql-sink ckan-sink/cygnusagent.sinks = ckan-sink/" \
    -e "s/cygnusagent.channels = hdfs-channel mysql-channel ckan-channel/cygnusagent.channels = ckan-channel/" \
    -e "s/org42/${CKAN_ORGANIZATION}/g" \
    -e "s/ckan_host = x.y.z.w/ckan_host = demo.ckan.org/g" \
    -e "s/api_key = ckanapikey/api_key = ${CKAN_API_KEY}/g" \
    -e "s/default_dataset = mydataset/default_dataset = ${CKAN_DATASET}/g"