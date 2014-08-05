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

_retrieveZippedArtifact() {
	local artifactURL="${1}"
	local localArtifact="${2}"
	local unzipTo="${3}"

	curl -s -k "${artifactURL}" > "${localArtifact}"

	if [ -d "${unzipTo}" ]; then
		rm -rf "${unzipTo}"
	fi
	unzip -qq "${localArtifact}" -d "${unzipTo}"
}

_updateLatestUpdateSite() {
	local updateHome="${1}"
    local absolutePathToLatest="${2}"
    local prefix="${3}"
    local latestRepoLabel="${4}"

    local currentPwd=$(pwd)
    cd "${updateHome}"
    local allFilesWithPrefix=( $(echo "${prefix}"* | tr ' ' '\n' | grep -E '[0-9]+\.[0-9]+\.[0-9]+.*' || true) )    
    cd "${currentPwd}"

    if [ ${#allFilesWithPrefix[@]} -gt 0 ]; then
        local latestUpdatePath=$( echo ${allFilesWithPrefix[@]} | tr ' ' '\n' | sort | tail -n 1 )
        local relpath=$( relativize ${absolutePathToLatest} ${updateHome}/${latestUpdatePath} )
        LSINFO "Creating redirection from '${absolutePathToLatest}' to '${latestUpdatePath}'" 
        createRedirect "${absolutePathToLatest}" "${relpath}" "${latestRepoLabel}"
    else
        LSDEBUG "No folder in '${updateHome}' have a name that start with '${prefix}' and that match the regex '[0-9]+\.[0-9]+\.[0-9]+.*'."
    fi
}

_publishUpdateSiteInStream() {
	local updateHome="${1}"
	local projectName="${2}"
	local category="${3}"
	local qualifiedVersion="${4}"
	local stream="${5}"

	local repoLabelPrefix="${projectName}${stream:+ ${stream}${STREAM_NAME_SUFFIX}}"

	local streamPath="${updateHome}${stream:+/${STREAMS_FOLDER}/${stream}${STREAM_NAME_SUFFIX}}"
	local relPathToUpdateSite=$( relativize "${streamPath}" "${updateHome}/${qualifiedVersion}" )

	LSDEBUG "Adding '${relPathToUpdateSite}' to composite repository '${streamPath}'"
	compositeRepository \
		-location "${streamPath}" \
		-add "${relPathToUpdateSite}" \
		-repositoryName "${repoLabelPrefix} ${category} builds" \
		-compressed
		createP2Index "${streamPath}"

	LSDEBUG "Updating latest of stream '${stream}${STREAM_NAME_SUFFIX}' @ '${streamPath}'"
	_updateLatestUpdateSite "${updateHome}" "${streamPath}${streamPath:+/}${LATEST_FOLDER}" "${stream}" "${repoLabelPrefix} latest ${category} build"
}

publishUpdateSite() {
	local wd="${1}"
	local projectName="${2}"
	local category="${3}"
	local artifactURL="${4}"
	local qualifiedVersion="${5}"
	local updateHome="${6}"

	# the update site
	LSINFO "Downloading '${artifactURL}'"
	local targetUpdateSiteName="update-site-${qualifiedVersion}"
	_retrieveZippedArtifact "${artifactURL}" "${wd}/${targetUpdateSiteName}.zip" "${wd}/${targetUpdateSiteName}"

	if [ ! -d "${updateHome}/${qualifiedVersion}" ]; then
		LSDEBUG "Creating folder '${updateHome}/${qualifiedVersion}'"
		mkdir -p "${updateHome}/${qualifiedVersion}"
	fi

	LSINFO "Copying update site to '${updateHome}/${qualifiedVersion}'"
	cp -Rf "${wd}/${targetUpdateSiteName}/"* "${updateHome}/${qualifiedVersion}"

	## streams update
	_publishUpdateSiteInStream "${updateHome}" "${projectName}" "${category}" "${qualifiedVersion}" "$(unqualifiedVersion ${qualifiedVersion})"
	_publishUpdateSiteInStream "${updateHome}" "${projectName}" "${category}" "${qualifiedVersion}" "$(minorVersion ${qualifiedVersion})"
	_publishUpdateSiteInStream "${updateHome}" "${projectName}" "${category}" "${qualifiedVersion}" "$(majorVersion ${qualifiedVersion})"
	_publishUpdateSiteInStream "${updateHome}" "${projectName}" "${category}" "${qualifiedVersion}" ""
}
