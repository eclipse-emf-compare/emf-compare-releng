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

_publishUpdateSiteInStream() {
	local projectName="${1}"
	local category="${2}"
	local updateHome="${3}"
	local qualifiedVersion="${4}"
	local stream="${5}"

	local repoLabelPrefix="${projectName}${stream:+ ${stream}.x}"

	local streamPath="${updateHome}${stream:+/${STREAMS_FOLDER}/${stream}.x}"
	local relPathToUpdateSite=$( relativize "${streamPath}" "${updateHome}/${qualifiedVersion}" )

	LSDEBUG "Adding '${relPathToUpdateSite}' to composite repository '${streamPath}'"
	compositeRepository \
		-location "${streamPath}" \
		-add "${relPathToUpdateSite}" \
		-repositoryName "${repoLabelPrefix} ${category} builds" \
		-compressed
		createP2Index "${streamPath}"

	LSDEBUG "Updating latest of stream '${stream}' @ '${streamPath}'"
	updateLatest "${streamPath}${streamPath:+/}${LATEST_FOLDER}" "${updateHome}" "${stream}" "${repoLabelPrefix} latest ${category} build"
}

publishUpdateSite() {
	local wd="${1}"
	local projectName="${2}"
	local category="${3}"
	local artifactURL="${4}"
	local qualifiedVersion="${5}"
	local updateHome="${6}"

	unqualifiedVersion="$(echo ${qualifiedVersion} | sed-regex 's/^([0-9]+\.[0-9]+\.[0-9]+)\..+$/\1/')"
	LSDEBUG "unqualifiedVersion is '${unqualifiedVersion}'"
	minorVersion="$(echo ${qualifiedVersion} | sed-regex 's/^([0-9]+\.[0-9]+)\.[0-9]+\..+$/\1/')"
	LSDEBUG "Minor stream name is '${minorVersion}.x'"
	majorVersion="$(echo ${qualifiedVersion} | sed-regex 's/^([0-9]+)\.[0-9]+\.[0-9]+\..+$/\1/')"
	LSDEBUG "Major stream name is '${majorVersion}.x'"

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
	_publishUpdateSiteInStream "${projectName}" "${category}" "${updateHome}" "${qualifiedVersion}" "${unqualifiedVersion}"
	_publishUpdateSiteInStream "${projectName}" "${category}" "${updateHome}" "${qualifiedVersion}" "${minorVersion}"
	_publishUpdateSiteInStream "${projectName}" "${category}" "${updateHome}" "${qualifiedVersion}" "${majorVersion}"
	_publishUpdateSiteInStream "${projectName}" "${category}" "${updateHome}" "${qualifiedVersion}" ""
}
