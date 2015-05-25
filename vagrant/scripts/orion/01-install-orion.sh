#!/bin/bash

if [ -d "fiware-orion" ]; then
    rm -rf "fiware-orion"
fi

# clone repository
git clone https://github.com/telefonicaid/fiware-orion

# build
cd fiware-orion/
if [ "${GIT_REV_ORION}" != "master" ]; then
    git checkout ${GIT_REV_ORION}
fi

if [[ "$(arch)" =~ i[3456]86 ]] ; then
    # Fix compilation errors for 32 bit
    # This is unsupported!!!
    replace "%lu" "%llu" --  src/lib/mongoBackend/MongoCommonRegister.cpp
    replace "%lu" "%llu" --  src/lib/mongoBackend/mongoSubscribeContext.cpp
    replace "%lu" "%llu" --  src/lib/ngsiNotify/Notifier.cpp
    replace "%lu" "%llu" --  src/lib/ngsi/ContextRegistrationVector.cpp
    replace "%lu" "%llu" --  src/lib/ngsi/ContextElementVector.cpp
    replace "%lu" "%llu" --  src/lib/ngsi/ContextElementResponseVector.cpp
    replace "%lu" "%llu" --  src/lib/ngsi/EntityIdVector.cpp
    replace "%lu" "%llu" --  src/lib/ngsi/ContextRegistrationAttributeVector.cpp
    replace "%lu" "%llu" --  src/lib/ngsi/AttributeAssociationList.cpp
    replace "%lu" "%u" --  src/lib/ngsi/Scope.cpp
    replace "%lu" "%llu" --  src/lib/ngsi/NotifyConditionVector.cpp
    replace "%lu" "%llu" --  src/lib/ngsi/ContextRegistrationResponseVector.cpp
    replace "%lu" "%llu" --  src/lib/ngsi/ContextAttributeVector.cpp
    replace "%lu" "%llu" --  src/lib/ngsi/MetadataVector.cpp
    replace "%lu" "%llu" --  src/lib/ngsi/ScopeVector.cpp
    replace "%lu" "%llu" --  src/lib/logMsg/logMsg.cpp
    replace "%lu" "%llu" --  src/lib/convenience/ContextAttributeResponseVector.cpp
    replace "%lu" "%llu" --  src/lib/parse/CompoundValueNode.cpp
    replace "%lu" "%llu" --  src/lib/rest/clientSocketHttp.cpp
    replace "%lu" "%llu" --  src/lib/parseArgs/paUsage.cpp
    replace "%lu" "%llu" --  src/lib/parseArgs/parseTest.cpp
    replace "%lu" "%llu" --  src/lib/parseArgs/paLimitCheck.cpp
    replace "%lu" "%llu" --  src/lib/orionTypes/TypeEntityVector.cpp
    replace "%ld" "%lld" --  src/app/proxyCoap/CoapController.cpp
    replace "%ld" "%lld" --  src/lib/parseArgs/paUsage.cpp
    replace "%ld" "%lld" --  src/lib/parseArgs/parseTest.cpp
    replace "%ld" "%lld" --  src/lib/parseArgs/paLimitCheck.cpp
fi

if [ "${DIST_TYPE}" = "debian" ]; then
    # fix distro detection for ubuntu 14.04.2 LTS
    if grep -q 'DISTRIB_DESCRIPTION="Ubuntu 14.04.2 LTS"' /etc/lsb-release ; then
	sed -e 's/"Ubuntu_14.04.1_LTS")/"Ubuntu_14.04.1_LTS" OR (${DISTRO} STREQUAL "Ubuntu_14.04.2_LTS"))/g' -i src/app/contextBroker/CMakeLists.txt
	sed -e 's/"Ubuntu_14.04.1_LTS")/"Ubuntu_14.04.1_LTS" OR (${DISTRO} STREQUAL "Ubuntu_14.04.2_LTS"))/g' -i src/app/proxyCoap/CMakeLists.txt
    fi
fi

INSTALL_DIR=${HOME} make install
