#!/bin/bash

export CYGNUS_SCRIPTS="${SCRIPTS_PATH}/cygnus"

su - ${CYGNUS_USER} <<EOF
# this is needed to be able to use the variables with the ${CYGNUS_USER} user
export SCRIPTS_PATH=${SCRIPTS_PATH}
export DIST_TYPE=${DIST_TYPE}
source ${SCRIPTS_PATH}/variables.sh
for f in \$( ls ${CYGNUS_SCRIPTS}/*.sh ) ; do
    bash \${f}
done
EOF

# after provisioning cygnus, the memory use of orion rises, so we restart the service
service orion restart
