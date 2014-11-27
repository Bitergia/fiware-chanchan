#!/bin/bash

REG_ORG="https://${IDM_HOSTNAME}/organizations/new"
CREATE_ORG="https://${IDM_HOSTNAME}/organizations"

readonly USER_AGENT="Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko/2008092816 Iceweasel/3.0.3 (Debian-3.0.3-3)"
readonly REG_ORG_PAGE_TXT="/tmp/register_org.output.txt"
readonly CREATE_ORG_FORM_TXT="/tmp/create_org.output.txt"
readonly COOKIES_FILE="/tmp/idmcookies.txt"

function _random_wait () {
    local time=$(( ($RANDOM % 3) + 2 ))
    sleep ${time}
}

function _cleanup () {
    rm -f "${REG_ORG_PAGE_TXT}"
    rm -f "${CREATE_ORG_FORM_TXT}"
}

echo "*** Creating IDM organization:  ${CC_ORG}"

curl \
    --location \
    --insecure \
    --user-agent "${USER_AGENT}" \
    --silent \
    --show-error \
    --cookie ${COOKIES_FILE} \
    --cookie-jar ${COOKIES_FILE} \
    --output "${REG_ORG_PAGE_TXT}" \
    --referer "https://${IDM_HOSTNAME}/home" \
    "${REG_ORG}"

_random_wait

form_utf8=$( sed "${REG_ORG_PAGE_TXT}" -n -e "s/^.*input name=\"utf8\" type=\"hidden\" value=\"\([^\"]*\).*$/\1/p" | recode html )
form_authenticity_token=$( sed "${REG_ORG_PAGE_TXT}" -n -e "s/^.*input name=\"authenticity_token\" type=\"hidden\" value=\"\([^\"]*\).*$/\1/p" )
form_org_name=${CC_ORG}
form_org_desc=${CC_ORG_DESC}
form_org_owners=$( sed "${REG_ORG_PAGE_TXT}" -n -e 's/.*name="organization\[owners\]" type="hidden" value="\([^"]*\).*$/\1/p' )

# fill the form and send it
curl \
    --location \
    --insecure \
    --user-agent "${USER_AGENT}" \
    --silent \
    --show-error \
    --cookie ${COOKIES_FILE} \
    --cookie-jar ${COOKIES_FILE} \
    --output "${CREATE_ORG_FORM_TXT}" \
    --referer "${REG_ORG}" \
    --form "utf8=${form_utf8}" \
    --form "authenticity_token=${form_authenticity_token}" \
    --form "organization[name]=${form_org_name}" \
    --form "organization[owners]=${form_org_owners}" \
    --form "organization[description]=${form_org_desc}" \
    --form "commit=Create Organization" \
    "${CREATE_ORG}"
    
_random_wait

_cleanup
