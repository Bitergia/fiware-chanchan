#!/bin/bash

# edit config
sed -i ${HOME}/${ORION_PEP_HOME}/config.js \
    -e  "s/module: 'keystone'/module: 'idm'/"\
    -e  "s/user: 'pepproxy'/user: '${CC_EMAIL}'/" \
    -e  "s/password: 'pepproxy'/password: '${CC_PASS}'/"\
    -e  "s/        protocol: 'http'/        protocol: 'https'/"\
    -e  "/domainName: 'Default',/ d"\
    -e  "/retries: 5,/ d"\
    -e  "s/        host: 'localhost'/        host: '${ORION_HOSTNAME}'/"\
    -e  "s/port: 5000/port: 443/"\
    -e  "s/port: 10026/port: ${ORION_PORT}/"\
    -e  "s/path: '\/v3\/role_assignments'/path: '\/user'/"\
    -e  "s/authPath: '\/v3\/auth\/tokens'/authPath: '\/oauth2\/authorize'/"\
    -e  "s/config.logLevel = 'FATAL'/config.logLevel = 'DEBUG'/"\
    -e  "s/config.componentName = 'orion'/config.componentName = 'contextbroker'/"\
    -e  "s/config.resourceNamePrefix = 'fiware:'/config.resourceNamePrefix = 'frn:'/"

# patch for Orion requests without headers

sed -i ${HOME}/${ORION_PEP_HOME}/lib/fiware-orion-pep.js \
    -e "/delete options.headers\['content-length'\];/a\  delete options.headers['fiware-service']; \n\ delete options.headers['fiware-servicepath'];"
