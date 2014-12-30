#!/bin/bash

export ORION_SCRIPTS="${SCRIPTS_PATH}/orion"

su - ${ORION_USER} <<EOF
# this is needed to be able to use the variables with the ${ORION_USER} user
export SCRIPTS_PATH=${SCRIPTS_PATH}
source ${SCRIPTS_PATH}/variables.sh
export DIST_TYPE=${DIST_TYPE}
for f in \$( ls ${ORION_SCRIPTS}/*.sh ) ; do
    bash \${f}
done
EOF
