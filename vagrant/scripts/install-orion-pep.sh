#!/bin/bash

export ORION_PEP_SCRIPTS="${SCRIPTS_PATH}/orion-pep"

su - ${ORION_PEP_USER} <<EOF
# this is needed to be able to use the variables with the ${ORION_PEP_USER} user
export SCRIPTS_PATH=${SCRIPTS_PATH}
export DIST_TYPE=${DIST_TYPE}
source ${SCRIPTS_PATH}/variables.sh
for f in \$( ls ${ORION_PEP_SCRIPTS}/*.sh ) ; do
    bash \${f}
done
EOF
