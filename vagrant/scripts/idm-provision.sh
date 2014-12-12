#!/bin/bash

export IDM_PROVISION_SCRIPTS="${SCRIPTS_PATH}/idm-provision"

cd ${IDM_PROVISION_SCRIPTS}
PATH=${PATH}:${IDM_PROVISION_SCRIPTS}

ORG_A="Organization A"
ORG_A_DESC="Demo Organization A"
ORG_B="Organization B"
ORG_B_DESC="Demo Organization B"
APP_NAME="Chanchan"
APP_DESC="Demo application"
APP_URL="http://${CC_HOSTNAME}"
APP_CALLBACK="http://${CC_HOSTNAME}/login"

ROLE_M="Member"
ROLE_P="Publisher"

PERM_P_NAME="Publicador"
PERM_P_DESC="Publicador en la aplicación"
PERM_P_ACT="POST"
PERM_P_RES="/publish"

# Admin user
create-idm-user.sh "${CC_USER_NAME}" "${CC_EMAIL}" "${CC_PASS}"

# Create organization A
create-idm-org.sh "${CC_EMAIL}" "${ORG_A}" "${ORG_A_DESC}"

# Add application to organization with custom role
create-idm-app.sh "${ORG_A}" "${APP_NAME}" "${APP_DESC}" "${APP_URL}" "${APP_CALLBACK}"

# Create organization B
create-idm-org.sh "${CC_EMAIL}" "${ORG_B}" "${ORG_B_DESC}"

# Add application to organization with custom role
create-idm-app.sh "${ORG_B}" "${APP_NAME}" "${APP_DESC}" "${APP_URL}" "${APP_CALLBACK}"

# Dump oauth credentials
dump-oauth-credentials.sh "${ORG_A}" "${APP_NAME}"
dump-oauth-credentials.sh "${ORG_B}" "${APP_NAME}"

create-role.sh "${ORG_A}" "${APP_NAME}" "${ROLE_M}"
create-role.sh "${ORG_A}" "${APP_NAME}" "${ROLE_P}"
create-role.sh "${ORG_B}" "${APP_NAME}" "${ROLE_M}"
create-role.sh "${ORG_B}" "${APP_NAME}" "${ROLE_P}"

create-permission.sh "${ORG_A}" "${APP_NAME}" "${PERM_P_NAME}" "${PERM_P_DESC}" "${PERM_P_ACT}" "${PERM_P_RES}"
create-permission.sh "${ORG_B}" "${APP_NAME}" "${PERM_P_NAME}" "${PERM_P_DESC}" "${PERM_P_ACT}" "${PERM_P_RES}"

add-permission-to-role.sh "${ORG_A}" "${APP_NAME}" "${ROLE_P}" "${PERM_P_NAME}"
add-permission-to-role.sh "${ORG_B}" "${APP_NAME}" "${ROLE_P}" "${PERM_P_NAME}"

# add some users with roles
create-idm-user.sh "User A" "user.a@${IDM_HOSTNAME}" "..test"
create-idm-user.sh "User B" "user.b@${IDM_HOSTNAME}" "..test"
create-idm-user.sh "User AB" "user.ab@${IDM_HOSTNAME}" "..test"
create-idm-user.sh "User 0" "user.0@${IDM_HOSTNAME}" "..test"
create-idm-user.sh "User M" "user.m@${IDM_HOSTNAME}" "..test"

add-user-with-role.sh "user.a@${IDM_HOSTNAME}" "${ORG_A}" "${APP_NAME}" "${ROLE_P}"
add-user-with-role.sh "user.ab@${IDM_HOSTNAME}" "${ORG_A}" "${APP_NAME}" "${ROLE_P}"
add-user-with-role.sh "user.m@${IDM_HOSTNAME}" "${ORG_A}" "${APP_NAME}" "${ROLE_M}"

add-user-with-role.sh "user.b@${IDM_HOSTNAME}" "${ORG_B}" "${APP_NAME}" "${ROLE_P}"
add-user-with-role.sh "user.ab@${IDM_HOSTNAME}" "${ORG_B}" "${APP_NAME}" "${ROLE_P}"
add-user-with-role.sh "user.m@${IDM_HOSTNAME}" "${ORG_B}" "${APP_NAME}" "${ROLE_M}"
