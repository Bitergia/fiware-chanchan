#!/bin/bash



# remove old git
if [ -d "${ORION_PEP_HOME}" ]; then
    rm -rf "${ORION_PEP_HOME}"
fi

# get ORION PEP
git clone https://github.com/telefonicaid/fiware-orion-pep.git ${ORION_PEP_HOME}

# compile KeyPass
cd ${ORION_PEP_HOME}
if [ "${GIT_REV_ORION_PEP}" != "master" ]; then
    git checkout ${GIT_REV_ORION_PEP}
fi


npm install
npm install production

cd ..
