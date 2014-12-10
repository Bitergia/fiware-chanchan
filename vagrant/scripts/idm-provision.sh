#!/bin/bash

export IDM_PROVISION_SCRIPTS="${SCRIPTS_PATH}/idm-provision"

cd ${IDM_PROVISION_SCRIPTS}

# Admin user
bash ./create-idm-user.sh "${CC_USER_NAME}" "${CC_EMAIL}" "${CC_PASS}"

# Create organization A
bash ./create-idm-org.sh "${CC_EMAIL}" "${ORG} A" "${ORG_DESC} A"

# Add application to organization with custom role
bash ${IDM_PROVISION_SCRIPTS}/create-idm-app.sh

# Create organization B
bash ./create-idm-org.sh "${CC_EMAIL}" "${ORG} B" "${ORG_DESC} B"

# Add application to organization with custom role
bash ${IDM_PROVISION_SCRIPTS}/create-idm-app.sh
