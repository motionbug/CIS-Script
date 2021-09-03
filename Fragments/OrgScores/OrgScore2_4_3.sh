#!/bin/zsh

script_dir=$(dirname ${0:A})
projectfolder=$(dirname $script_dir)

source ${projectfolder}/Header.sh

CISLevel="1"
audit="2.4.3 Disable Screen Sharing (Automated)"
orgScore="OrgScore2_4_3"
emptyVariables
# Verify organizational score
runAudit
# If organizational score is 1 or true, check status of client
if [[ "${auditResult}" == "1" ]]; then
	method="Script"
	remediate="Script > sudo launchctl disable system/com.apple.screensharing"

	screenSharing=$(launchctl print-disabled system | grep -c '"com.apple.screensharing" => true')
	if [[ "$screenSharing" == "1" ]]; then
		result="Passed"
		comment="Screen Sharing: Disabled"
	else
		result="Failed"
		comment="Screen Sharing: Enabled"
	fi
fi
printReport