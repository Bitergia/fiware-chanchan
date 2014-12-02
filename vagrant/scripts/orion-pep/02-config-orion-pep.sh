#!/bin/bash

# edit config
sed -i ${HOME}/${ORION_PEP_HOME}/config.js \
    -e  "s/module: 'keystone'/module: 'idm'/"\
    -e  "s/user: 'pepproxy'/user: 'bitergiatest@mailinator.com'/" \
    -e  "s/password: 'pepproxy'/password: 'password'/"\
    -e  "s/        protocol: 'http'/        protocol: 'https'/"\
    -e  "s/        host: 'localhost'/        host: 'idm.server'/"\
    -e  "s/port: 5000/port: 443/"\
    -e  "s/path: '\/v3\/role_assignments'/path: '\/user'/"\
    -e  "s/authPath: '\/v3\/auth\/tokens'/authPath: '\/oauth2\/authorize'/"\
    -e  "s/config.logLevel = 'FATAL'/config.logLevel = 'DEBUG'/"

# patch templates duplicate
sed -i ${HOME}/${ORION_PEP_HOME}/lib/templates/validationRequest.xml \
    -e  "s/CombinedDecision=\"false\">/>/g"