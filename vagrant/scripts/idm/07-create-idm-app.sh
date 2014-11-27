#!/bin/bash

REG_APP="https://${IDM_HOSTNAME}/applications/new"
CREATE_APP="https://${IDM_HOSTNAME}/applications"

readonly USER_AGENT="Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko/2008092816 Iceweasel/3.0.3 (Debian-3.0.3-3)"
readonly REG_APP_PAGE_TXT="/tmp/register_app.output.txt"
readonly STEP2_APP_PAGE_TXT="/tmp/step2_app.output.txt"
readonly STEP3_APP_PAGE_TXT="/tmp/step3_app.output.txt"
readonly CREATE_APP_FORM_TXT="/tmp/create_app.output.txt"
readonly COOKIES_FILE="/tmp/idmcookies.txt"
readonly HEADER="/tmp/appheader.txt"

function _random_wait () {
    local time=$(( ($RANDOM % 3) + 2 ))
    sleep ${time}
}

function _cleanup () {
    rm -f "${REG_APP_PAGE_TXT}"
    rm -f "${STEP2_APP_PAGE_TXT}"
    rm -f "${STEP3_APP_PAGE_TXT}"
    rm -f "${CREATE_APP_FORM_TXT}"
    rm -f "${HEADER}"
    rm -f "${COOKIES_FILE}"
}

echo "*** Creating IDM application:  ${CC_APP}"

curl \
    --location \
    --insecure \
    --user-agent "${USER_AGENT}" \
    --silent \
    --show-error \
    --cookie ${COOKIES_FILE} \
    --cookie-jar ${COOKIES_FILE} \
    --output "${REG_APP_PAGE_TXT}" \
    --referer "https://${IDM_HOSTNAME}/home" \
    "${REG_APP}"

_random_wait

form_utf8=$( sed "${REG_APP_PAGE_TXT}" -n -e "s/^.*input name=\"utf8\" type=\"hidden\" value=\"\([^\"]*\).*$/\1/p" | recode html )
form_authenticity_token=$( sed "${REG_APP_PAGE_TXT}" -n -e "s/^.*input name=\"authenticity_token\" type=\"hidden\" value=\"\([^\"]*\).*$/\1/p" )
form_app_name=${CC_APP}
form_app_desc=${CC_APP_DESC}
form_app_url=${CC_APP_URL}
form_app_callback=${CC_APP_CALLBACK}

# fill the form and send it
curl \
    --location \
    --insecure \
    --user-agent "${USER_AGENT}" \
    --silent \
    --show-error \
    --cookie ${COOKIES_FILE} \
    --cookie-jar ${COOKIES_FILE} \
    --output "${CREATE_APP_FORM_TXT}" \
    --referer "${REG_APP}" \
    --form "utf8=${form_utf8}" \
    --form "authenticity_token=${form_authenticity_token}" \
    --form "application[name]=${form_app_name}" \
    --form "application[description]=${form_app_desc}" \
    --form "application[url]=${form_app_url}" \
    --form "application[callback_url]=${form_app_callback}" \
    --form "commit=Next" \
    --dump-header "${HEADER}" \
    "${CREATE_APP}"
    
_random_wait

REFERER_STEP2=$( sed "${HEADER}" -n -e 's/^Location: \(.*\)$/\1/p' )
NEXT_URL="https://${IDM_HOSTNAME}"$( sed ${CREATE_APP_FORM_TXT} -n -e 's/^.*href="\([^"]*\)" class="next-step".*$/\1/p' )

curl \
    --location \
    --insecure \
    --user-agent "${USER_AGENT}" \
    --silent \
    --show-error \
    --cookie ${COOKIES_FILE} \
    --cookie-jar ${COOKIES_FILE} \
    --output "${STEP2_APP_PAGE_TXT}" \
    --referer "${REFERER_STEP2}" \
    "${NEXT_URL}"

_random_wait

FINAL_URL="https://${IDM_HOSTNAME}"$( sed ${STEP2_APP_PAGE_TXT} -n -e 's/^.*href="\([^"]*\)" class="next-step".*$/\1/p' )

curl \
    --location \
    --insecure \
    --user-agent "${USER_AGENT}" \
    --silent \
    --show-error \
    --cookie ${COOKIES_FILE} \
    --cookie-jar ${COOKIES_FILE} \
    --output "${STEP3_APP_PAGE_TXT}" \
    --referer "${NEXT_URL}" \
    "${FINAL_URL}"

_random_wait

# get oauth credentials for the app

CLIENT_ID=$( cat ${STEP3_APP_PAGE_TXT} | tr -d '\n' | tr -d ' ' | sed -n -e 's|.*divclass="client-id"><h6>ClientID</h6><p>\([^<]*\)</p></div>.*|\1|p' )
CLIENT_SECRET=$( sed ${STEP3_APP_PAGE_TXT} -n -e 's/^.*span class="site-client-secret">\(.*\)<\/span>/\1/p')

cat <<EOF > "${CC_OAUTH_CREDENTIALS}"
CLIENT_ID=${CLIENT_ID}
CLIENT_SECRET=${CLIENT_SECRET}
EOF

_cleanup
