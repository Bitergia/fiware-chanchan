#!/bin/bash

# edit config
sed -i ${HOME}/${KEYPASS_HOME}/conf/config.yml \
    -e "s/8080/7070/"  \
    -e "s/8081/7071/" \
    -e "s/level: INFO/level: DEBUG/" 