#!/bin/bash

export IDM_PROVISION_SCRIPTS="${SCRIPTS_PATH}/idm-provision"

# Admin user
bash ${IDM_PROVISION_SCRIPTS}/create-idm-user.sh

# Create organization A
export CC_ORG="${ORG} A"
export CC_ORG_DESC="${ORG_DESC} A"
bash ${IDM_PROVISION_SCRIPTS}/create-idm-org.sh

# Add application to organization with custom role
bash ${IDM_PROVISION_SCRIPTS}/create-idm-app.sh

# Create organization B
export CC_ORG="${ORG} B"
export CC_ORG_DESC="${ORG_DESC} B"
bash ${IDM_PROVISION_SCRIPTS}/create-idm-org.sh

# Add application to organization with custom role
bash ${IDM_PROVISION_SCRIPTS}/create-idm-app.sh
