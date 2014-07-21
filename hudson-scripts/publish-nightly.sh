#!/bin/sh
# ====================================================================
# Copyright (c) 2014 Obeo
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
#
# Contributors:
#    Obeo - initial API and implementation
# ====================================================================

if [ $# -ne 2 ]; then
     echo "Execution aborted. One or more of the required parameters is not set. 

Usage: $0 artifactURL unqualifiedVersion qualifiedVersion

- artifactURL: the URL where the zipped update site to publish can be donwload.
- qualifiedVersion: the qualified version of the update site to publish.
"
fi

artifactURL="${1}"
qualifiedVersion="${2}"

source "$(dirname "${0}")/init.sh"

LSINFO "== Publishing nightly build '${PROJECT_NAME} ${qualifiedVersion}' == "

unqualifiedVersion="$(echo ${qualifiedVersion} | sed-regex 's/^([0-9]+\.[0-9]+\.[0-9]+)\..+$/\1/')"
LSDEBUG "unqualifiedVersion is '${unqualifiedVersion}'"
minorVersion="$(echo ${qualifiedVersion} | sed-regex 's/^([0-9]+\.[0-9]+)\.[0-9]+\..+$/\1/')"
LSDEBUG "Minor stream name is '${minorVersion}.x'"
majorVersion="$(echo ${qualifiedVersion} | sed-regex 's/^([0-9]+)\.[0-9]+\.[0-9]+\..+$/\1/')"
LSDEBUG "Major stream name is '${majorVersion}.x'"

# the update site

LSINFO "Downloading '${artifactURL}'"
artifactName="update-site.zip"
if [ -f "${WORKING_DIRECTORY}/${artifactName}" ]; then
	rm -f "${WORKING_DIRECTORY}/${artifactName}"
fi
curl -s -k "${artifactURL}" > "${WORKING_DIRECTORY}/${artifactName}"

LSINFO "Unziping '${artifactName}'"
if [ -d "${WORKING_DIRECTORY}/update-site" ]; then
	rm -rf "${WORKING_DIRECTORY}/update-site"
fi
unzip -qq "${WORKING_DIRECTORY}/${artifactName}" -d "${WORKING_DIRECTORY}/update-site"

if [ ! -d "${UPDATE_NIGHTLY_HOME}/${qualifiedVersion}" ]; then
	LSINFO "Creating folder '${UPDATE_NIGHTLY_HOME}'"
	mkdir -p "${UPDATE_NIGHTLY_HOME}/${qualifiedVersion}"
else
	LSDEBUG "Folder '${WORKING_DIRECTORY}/${UPDATE_NIGHTLY_HOME}' already exists, do nothing"
fi
LSINFO "Copying update site to '${UPDATE_NIGHTLY_HOME}'"
cp -rf "${WORKING_DIRECTORY}/update-site/"* "${UPDATE_NIGHTLY_HOME}/${qualifiedVersion}"

## streams update

updateStream() {
	local pathToVersion="${1}"
	local stream="${2}"

	local streamPath="${stream:+streams/${stream}.x}"
	local repoPrefix="${PROJECT_NAME}${stream:+ ${stream}.x}"

	LSINFO "Adding '${pathToVersion}' to '${UPDATE_NIGHTLY_HOME}/${streamPath}'"

	composite-repository \
		-location "${UPDATE_NIGHTLY_HOME}/${streamPath}" \
		-add "${pathToVersion}" \
		-repositoryName "${repoPrefix} nightly builds" \
		-compressed
		createP2Index "${UPDATE_NIGHTLY_HOME}/${streamPath}"

	updateLatest "${UPDATE_NIGHTLY_HOME}/${streamPath}${streamPath:+/}latest" "${stream}" "${repoPrefix} latest nightly build"
}

updateStream "../../${qualifiedVersion}" "${unqualifiedVersion}"
updateStream "../../${qualifiedVersion}" "${minorVersion}"
updateStream "../../${qualifiedVersion}" "${majorVersion}"
updateStream "${qualifiedVersion}"       ""

LSINFO "== '${PROJECT_NAME} ${qualifiedVersion}' has been published @ '${UPDATE_NIGHTLY_URL}/${qualifiedVersion}' == "

# the javadoc

# the documentation
