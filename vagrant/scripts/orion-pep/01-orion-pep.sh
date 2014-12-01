#!/bin/bash



# remove old git
if [ -d "fiware-orion-pep" ]; then
    rm -rf "fiware-orion-pep"
fi

# get ORION PEP
git clone https://github.com/telefonicaid/fiware-orion-pep.git ${ORION_PEP_HOME}

# compile KeyPass
cd ${ORION_PEP_HOME}
npm install
npm install production

cd ..
