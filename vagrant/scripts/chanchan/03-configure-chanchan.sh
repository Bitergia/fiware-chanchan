#!/bin/bash

IDM_URL="https://${IDM_HOSTNAME}"

${UTILS_PATH}/update_hosts.sh ${CC_HOSTNAME}

su - chanchan <<EOF
sed -i ${CC_APP_SERVER_PATH}/config.js \
  -e "/^[ ]*config.idm_url =/c config.idm_url = '${IDM_URL}';" \
  -e "/^[ ]*config.callback_url =/c config.callback_url = '${CC_APP_CALLBACK}'"
EOF
if [ -f "${CC_OAUTH_CREDENTIALS}" ]; then
    ORGANIZATIONS=$( (echo "{" ; (cat "${CC_OAUTH_CREDENTIALS}" | paste -s -d ',') ; echo "}")  | python -m json.tool )
    su - chanchan <<EOF
perl -0 -p -i -e "s/var organizations = .*\}\};?/var organizations = ${ORGANIZATIONS};/ms" ${CC_APP_CLIENT_PATH}/app/app.js
EOF
fi
