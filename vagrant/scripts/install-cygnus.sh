#!/bin/bash

export CYGNUS_SCRIPTS="${SCRIPTS_PATH}/cygnus"

su - ${CYGNUS_USER} <<EOF
# this is needed to be able to use the variables with the ${CYGNUS_USER} user
export SCRIPTS_PATH=${SCRIPTS_PATH}
source ${SCRIPTS_PATH}/variables.sh
export DIST_TYPE=${DIST_TYPE}
for f in \$( ls ${CYGNUS_SCRIPTS}/*.sh ) ; do
    bash \${f}
done
EOF
