#!/bin/bash
#set -x
declare -A URL=(
    [idm]="${IDM_URL}"
    [home]="${IDM_URL}/home"
    [applications]="${IDM_URL}/applications"
    [register_application]="${IDM_URL}/applications/new"
    [add_role]="${IDM_URL}/relation/customs"
    [add_permission]="${IDM_URL}/permission/customs"
    [permissions]="${IDM_URL}/permissions?relation_id="
)

declare -A OUTPUT=(
    [register_application]="/tmp/register_application.output.html"
    [applications]="/tmp/applications.output.html"
    [application_roles]="/tmp/application_roles.output.html"
    [finish_registration]="/tmp/finish_registration.output.html"
    [header]="/tmp/header.txt"
    [add_role]="/tmp/add_role.output.html"
    [add_permission]="/tmp/add_permission.output.html"
    [permissions]="/tmp/permissions.output.html"
    [add_role_permission]="/tmp/add_role_permissions.output.html"
)

declare -A COOKIES_FILE=(
    [user]="/tmp/cookies.${CC_USER_NAME// }.txt"
    [organization]="/tmp/cookies.${CC_ORG// }.txt"
)

CURL_OPTIONS="--location --insecure --silent --show-error --cookie ${COOKIES_FILE[organization]} --cookie-jar ${COOKIES_FILE[organization]}"

function _random_wait () {
    local time=$(( ($RANDOM % 3) + 2 ))
    sleep ${time}
}

function _cleanup () {
    # remove all output files
    #echo "    - Cleaning output files"
    for f in "${OUTPUT[@]}" ; do
	if [ -f "${f}" ]; then
	    rm -f "${f}"
	fi
    done
}

function _register_application () {

    local name="$1"
    local description="$2"
    local url="$3"
    local callback="$4"

    curl ${CURL_OPTIONS} \
	 --output "${OUTPUT[register_application]}" \
	 --referer "${URL[home]}" \
	 "${URL[register_application]}"

    _random_wait

    utf8=$( sed "${OUTPUT[register_application]}" -n -e "s/^.*input name=\"utf8\" type=\"hidden\" value=\"\([^\"]*\).*$/\1/p" | recode html )
    authenticity_token=$( sed "${OUTPUT[register_application]}" -n -e "s/^.*input name=\"authenticity_token\" type=\"hidden\" value=\"\([^\"]*\).*$/\1/p" )

    # fill the form and send it
    curl ${CURL_OPTIONS} \
	 --output "${OUTPUT[applications]}" \
	 --referer "${URL[register_application]}" \
	 --form "utf8=${utf8}" \
	 --form "authenticity_token=${authenticity_token}" \
	 --form "application[name]=${name}" \
	 --form "application[description]=${description}" \
	 --form "application[url]=${url}" \
	 --form "application[callback_url]=${callback}" \
	 --form "commit=Next" \
	 --dump-header "${OUTPUT[header]}" \
	"${URL[applications]}"

    _random_wait
}

function _set_application_logo () {

    URL[referer_application_logo]=$( sed "${OUTPUT[header]}" -n -e 's/^Location: \(.*\)$/\1/p' )
    URL[application_roles]="${URL[idm]}"$( sed "${OUTPUT[applications]}" -n -e 's/^.*href="\([^"]*\)" class="next-step".*$/\1/p' )

    # logo - just skip it for now
    curl ${CURL_OPTIONS} \
	 --output "${OUTPUT[application_roles]}" \
	 --referer "${URL[referer_application_logo]}" \
	 "${URL[application_roles]}"

    _random_wait
}

function _add_role () {

    local name="$1"

    utf8=$( sed "${OUTPUT[application_roles]}" -n -e "s/^.*input name=\"utf8\" type=\"hidden\" value=\"\([^\"]*\).*$/\1/p" | recode html )
    authenticity_token=$( sed "${OUTPUT[application_roles]}" -n -e "s/^.*input name=\"authenticity_token\" type=\"hidden\" value=\"\([^\"]*\).*$/\1/p" )
    actor_id=$(sed "${OUTPUT[application_roles]}" -n -e "s/^.*input.*name=\"relation_custom\[actor_id\]\" type=\"hidden\" value=\"\([^\"]*\).*$/\1/p" )

    curl ${CURL_OPTIONS} \
	 --output "${OUTPUT[add_role]}" \
	 --referer "${URL[application_roles]}" \
	 --data "utf8=${utf8}" \
	 --data "authenticity_token=${authenticity_token}" \
	 --data "relation_custom[actor_id]=${actor_id}" \
	 --data "relation_custom[name]=${name}" \
	 --data "commit=Save" \
	 --header "X-Requested-With: XMLHttpRequest" \
	 --header "X-CSRF-Token: ${authenticity_token}" \
	 --header "Accept: */*;q=0.5, text/javascript, application/javascript, application/ecmascript, application/x-ecmascript" \
	 "${URL[add_role]}"

    _random_wait

    role_id=$( cat "${OUTPUT[add_role]}" | grep "id:" | tr -d ' ' | sed -e 's/^id://g' -e 's/,$//g' )

    curl ${CURL_OPTIONS} \
	 --output "${OUTPUT[permissions]}" \
	 --referer "${URL[application_roles]}" \
	 --header "X-Requested-With: XMLHttpRequest" \
	 --header "X-CSRF-Token: ${authenticity_token}" \
	 "${URL[permissions]}${role_id}"

    _random_wait

}

function _add_permission () {

    local name="$1"
    local description="$2"
    local action="$3"
    local resource="$4"

    utf8=$( sed "${OUTPUT[application_roles]}" -n -e "s/^.*input name=\"utf8\" type=\"hidden\" value=\"\([^\"]*\).*$/\1/p" | recode html )
    authenticity_token=$( sed "${OUTPUT[application_roles]}" -n -e "s/^.*input name=\"authenticity_token\" type=\"hidden\" value=\"\([^\"]*\).*$/\1/p" )
    actor_id=$(sed "${OUTPUT[application_roles]}" -n -e "s/^.*input.*name=\"relation_custom\[actor_id\]\" type=\"hidden\" value=\"\([^\"]*\).*$/\1/p" )

    role_id=$( cat "${OUTPUT[add_role]}" | grep "id:" | tr -d ' ' | sed -e 's/^id://g' -e 's/,$//g' )

    curl ${CURL_OPTIONS} \
	 --output "${OUTPUT[add_permission]}" \
	 --referer "${URL[application_roles]}" \
	 --data "utf8=${utf8}" \
	 --data "authenticity_token=${authenticity_token}" \
	 --data "permission_custom[actor_id]=${actor_id}" \
	 --data "permission_custom[name]=${name}" \
	 --data "permission_custom[description]=${description}" \
	 --data "permission_custom[action]=${action}" \
	 --data "permission_custom[object]=${resource}" \
	 --data "permission_custom[xml]=" \
	 --data "commit=Create permission" \
	 --header "X-Requested-With: XMLHttpRequest" \
	 --header "X-CSRF-Token: ${authenticity_token}" \
	 --header "Accept: */*;q=0.5, text/javascript, application/javascript, application/ecmascript, application/x-ecmascript" \
	 "${URL[add_permission]}"

    _random_wait

    curl ${CURL_OPTIONS} \
	 --output "${OUTPUT[permissions]}" \
	 --referer "${URL[application_roles]}" \
	 --header "X-Requested-With: XMLHttpRequest" \
	 --header "X-CSRF-Token: ${authenticity_token}" \
	 "${URL[permissions]}${role_id}"

    _random_wait

}

function _add_permission_to_role () {

    utf8=$( sed "${OUTPUT[application_roles]}" -n -e "s/^.*input name=\"utf8\" type=\"hidden\" value=\"\([^\"]*\).*$/\1/p" | recode html )
    authenticity_token=$( sed "${OUTPUT[application_roles]}" -n -e "s/^.*input name=\"authenticity_token\" type=\"hidden\" value=\"\([^\"]*\).*$/\1/p" )
    actor_id=$(sed "${OUTPUT[application_roles]}" -n -e "s/^.*input.*name=\"relation_custom\[actor_id\]\" type=\"hidden\" value=\"\([^\"]*\).*$/\1/p" )

    role_id=$( cat "${OUTPUT[add_role]}" | grep "id:" | tr -d ' ' | sed -e 's/^id://g' -e 's/,$//g' )
    permission_id=$( cat "${OUTPUT[add_permission]}" | grep "id:" | tr -d ' ' | sed -e 's/^id://g' -e 's/,$//g' -e "s/'//g" )

    relations_list=$( sed "${OUTPUT[permissions]}" -n -e 's/^.*checked="checked".*value="\([^"]*\)".*$/\1/p' )

    curl ${CURL_OPTIONS} \
	 --output "${OUTPUT[add_role_permission]}" \
	 --referer "${URL[application_roles]}" \
	 --data "utf8=${utf8}" \
	 --data "_method=put" \
	 --data "authenticity_token=${authenticity_token}" \
	 $( if [ -z ${relations_list} ]; then
		echo "--data \"relation_custom[permission_ids]=\""
	    else
		for id in ${relations_list} ; do
		    echo "--data \"relation_custom[permission_ids]=${id}\""
		done
	    fi
	 ) \
	 --data "relation_custom[permission_ids]=${permission_id}" \
	 --header "X-Requested-With: XMLHttpRequest" \
	 --header "X-CSRF-Token: ${authenticity_token}" \
	 --header "Accept: */*;q=0.5, text/javascript, application/javascript, application/ecmascript, application/x-ecmascript" \
	 "${URL[add_role]}/${role_id}?section=permissions"

    _random_wait

    curl ${CURL_OPTIONS} \
	 --output "${OUTPUT[permissions]}" \
	 --referer "${URL[application_roles]}" \
	 --header "X-Requested-With: XMLHttpRequest" \
	 --header "X-CSRF-Token: ${authenticity_token}" \
	 "${URL[permissions]}${role_id}"

    _random_wait

}

function _finish_registration () {

    URL[finish_registration]="${URL[idm]}"$( sed "${OUTPUT[application_roles]}" -n -e 's/^.*href="\([^"]*\)" class="next-step".*$/\1/p' )

    # finish registration
    curl ${CURL_OPTIONS} \
	 --output "${OUTPUT[finish_registration]}" \
	 --referer "${URL[application_roles]}" \
	 "${URL[finish_registration]}"

    _random_wait

}

function _dump_oauth_credentials () {

    # get oauth credentials for the app
    CLIENT_ID=$( cat "${OUTPUT[finish_registration]}" | tr -d '\n' | tr -d ' ' |
		       sed -n -e 's|.*divclass="client-id"><h6>ClientID</h6><p>\([^<]*\)</p></div>.*|\1|p' )
    CLIENT_SECRET=$( sed "${OUTPUT[finish_registration]}" -n -e 's/^.*span class="site-client-secret">\(.*\)<\/span>/\1/p')

    echo "{\"${CC_ORG}\": { \"client_id\": \"${CLIENT_ID}\", \"client_secret\": \"${CLIENT_SECRET}\"}}" >> "${CC_OAUTH_CREDENTIALS}"
    cat "${CC_OAUTH_CREDENTIALS}" | sort -u > "${CC_OAUTH_CREDENTIALS}.tmp"
    mv "${CC_OAUTH_CREDENTIALS}.tmp" "${CC_OAUTH_CREDENTIALS}"
}


### main
echo "*** Creating IDM application [${CC_APP}] on [${CC_ORG}]"

_register_application "${CC_APP}" "${CC_APP_DESC}" "${CC_APP_URL}" "${CC_APP_CALLBACK}"
_set_application_logo

_add_role "${CC_ROLE}"
_add_permission "${CC_PERM}" "${CC_PERM_DESC}" "${CC_PERM_ACTION}" "${CC_PERM_RESOURCE}"
_add_permission_to_role

_finish_registration

_dump_oauth_credentials

_cleanup
