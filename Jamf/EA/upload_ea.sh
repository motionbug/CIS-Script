#!/bin/bash

script_dir=$(dirname ${0:A})
projectfolder=$(dirname $script_dir)

jamfpro_user=""
jamfpro_password=""

# Get JSS URL from Jamf Pro prefrences
#jamfpro_url=$(defaults read /Library/Preferences/com.jamfsoftware.jamf.plist jss_url)
jamfpro_url=""

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "password"
if [[ "$4" != "" ]] && [[ "$jamfpro_user" == "" ]]; then
    jamfpro_user=$4
fi

if [[ "$5" != "" ]] && [[ "$jamfpro_password" == "" ]]; then
    jamfpro_password=$5
fi

GetJamfProAPIToken() {
    # This function uses Basic Authentication to get a new bearer token for API authentication.
    # Use user account's username and password credentials with Basic Authorization to request a bearer token.

    if [[ $(/usr/bin/sw_vers -productVersion | awk -F . '{print $1}') -lt 12 ]]; then
        api_token=$(/usr/bin/curl -X POST --silent -u "${jamfpro_user}:${jamfpro_password}" "${jamfpro_url}api/v1/auth/token" | python -c 'import sys, json; print json.load(sys.stdin)["token"]')
    else
        api_token=$(/usr/bin/curl -X POST --silent -u "${jamfpro_user}:${jamfpro_password}" "${jamfpro_url}api/v1/auth/token" | plutil -extract token raw -)
    fi
}

APITokenValidCheck() {
    # Verify that API authentication is using a valid token by running an API command
    # which displays the authorization details associated with the current API user.
    # The API call will only return the HTTP status code.

    api_authentication_check=$(/usr/bin/curl --write-out %{http_code} --silent --output /dev/null "${jamfpro_url}api/v1/auth" --request GET --header "Authorization: Bearer ${api_token}")
}

InvalidateToken() {
    # Verify that API authentication is using a valid token by running an API command
    # which displays the authorization details associated with the current API user.
    # The API call will only return the HTTP status code.

    APITokenValidCheck

    # If the api_authentication_check has a value of 200, that means that the current
    # bearer token is valid and can be used to authenticate an API call.

    if [[ ${api_authentication_check} == 200 ]]; then

        # If the current bearer token is valid, an API call is sent to invalidate the token.

        authToken=$(/usr/bin/curl "${jamfpro_url}api/v1/auth/invalidate-token" --silent --header "Authorization: Bearer ${api_token}" -X POST)

        # Explicitly set value for the api_token variable to null.
        api_token=""
    fi
}

GetJamfProAPIToken

#printf $api_token

eaXMLfolder="/Users/rob.potvin/Git/CIS-Script/Jamf/EA/"

eaName=$(cat "$eaXML" | grep "<computer_extension_attribute>" | awk -F "<name>|</name>" '{print $2}')

#for AFILE in ${FILES[@]}; do

# curl -X POST -H "Content-Type: application/xml" \
#      --data-binary "@${AFILE}" \
#       --header "Authorization: Bearer ${api_token}" \
#        "${jamfpro_url}JSSResource/computerextensionattributes/id/0"
# curl -s -k  -H "content-type: text/xml" ${jamfpro_url}JSSResource/computerextensionattributes/id/0 --data-binary @"${AFILE}" -X POST

#done

testobj="/Users/rob.potvin/Git/CIS-Script/Jamf/EA/output.xml"

curl -X POST -H "Content-Type: application/xml" --data-binary "@$testobj" --header "Authorization: Bearer ${api_token}" "${jamfpro_url}JSSResource/computerextensionattributes/id/0"
