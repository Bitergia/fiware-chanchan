#!/bin/bash

# edit config
sed -i ${HOME}/${ORION_PEP_HOME}/conf/config.yml \
    -e  "s/module: 'keystone'/module: 'idm'/"\
    -e  "s/user: 'pepproxy'/user: 'bitergiatest@mailinator.com'/" \
    -e  "s/password: 'pepproxy'/password: 'password'/"\
    -e  "s/port: 5000/port: 80/"\
    -e  "s/path: '\/v3\/role_assignments'/path: '\/user'/"\
    -e  "s/authPath: '\/v3\/auth\/tokens'/authPath: '\/oauth2\/authorize'/"\
    -e  "s/config.logLevel = 'FATAL'/config.logLevel = 'DEBUG'/"