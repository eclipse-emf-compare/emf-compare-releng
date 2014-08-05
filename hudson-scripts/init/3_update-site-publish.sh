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
    local stream="${2}"
    local latestRepoLabel="${3}"

    local currentPwd=$(pwd)
    cd "${updateHome}"
    local updateSitesInStream=( $(echo "${stream}"* | tr ' ' '\n' | grep -E '[0-9]+\.[0-9]+\.[0-9]+.*' || true) )    
    cd "${currentPwd}"

    if [ ${#updateSitesInStream[@]} -gt 0 ]; then
    	local absolutePathToLatest=$( streamLatestAbsolutePath "${updateHome}" "${stream}" )
        local latestUpdateSite=$( echo ${updateSitesInStream[@]} | tr ' ' '\n' | sort | tail -n 1 )
        local relpath=$( relativize ${absolutePathToLatest} ${updateHome}/${latestUpdateSite} )
        LSDEBUG "Creating redirection from '${absolutePathToLatest}' to '${relpath}'" 
        createRedirect "${absolutePathToLatest}" "${relpath}" "${latestRepoLabel}"
    else
        LSDEBUG "No folder in '${updateHome}' have a name that start with '${stream}' and that match the regex '[0-9]+\.[0-9]+\.[0-9]+.*'."
    fi
}

_publishUpdateSiteInStream() {
	local updateHome="${1}"
	local projectName="${2}"
	local category="${3}"
	local qualifiedVersion="${4}"
	local stream="${5}"

	local _streamAbsolutePath=$( streamAbsolutePath "${updateHome}" "${stream}" )
	local relativePathToUpdateSite=$( relativize "${_streamAbsolutePath}" "${updateHome}/${qualifiedVersion}" )

	LSDEBUG "Adding '${relativePathToUpdateSite}' to composite repository '$(streamLabel "${stream}")'"
	compositeRepository \
		-location "${_streamAbsolutePath}" \
		-add "${relativePathToUpdateSite}" \
		-repositoryName $(streamRepositoryLabel "${projectName}" "${category}" "${stream}") \
		-compressed
		createP2Index "${_streamAbsolutePath}"

	LSDEBUG "Updating latest link of ${category} stream '$(streamLabel "${stream}")'"
	_updateLatestUpdateSite "${updateHome}" "${stream}" $(streamLatestRepositoryLabel "${projectName}" "${category}" "${stream}")
}

publishUpdateSite() {
	local wd="${1}"
	local updateHome="${2}"
	local projectName="${3}"
	local category="${4}"
	local artifactURL="${5}"
	local qualifiedVersion="${6}"

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
	LSINFO "Publishing update site in stream $(streamLabel $(unqualifiedVersion ${qualifiedVersion}))"
	_publishUpdateSiteInStream "${updateHome}" "${projectName}" "${category}" "${qualifiedVersion}" "$(unqualifiedVersion ${qualifiedVersion})"
	LSINFO "Publishing update site in stream $(streamLabel $(minorVersion ${qualifiedVersion}))"
	_publishUpdateSiteInStream "${updateHome}" "${projectName}" "${category}" "${qualifiedVersion}" "$(minorVersion ${qualifiedVersion})"
	LSINFO "Publishing update site in stream $(streamLabel $(majorVersion ${qualifiedVersion}))"
	_publishUpdateSiteInStream "${updateHome}" "${projectName}" "${category}" "${qualifiedVersion}" "$(majorVersion ${qualifiedVersion})"
	LSINFO "Publishing update site in global stream"
	_publishUpdateSiteInStream "${updateHome}" "${projectName}" "${category}" "${qualifiedVersion}" ""
}
