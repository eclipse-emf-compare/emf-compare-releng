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
	local home="${3}"
	local qualifiedVersion="${4}"
	local stream="${5}"

	local repoLabelPrefix="${projectName}${stream:+ ${stream}.x}"

	local streamPath="${home}${stream:+/${STREAMS_FOLDER}/${stream}.x}"
	local relPathToUpdateSite=$( relativize "${streamPath}" "${home}/${qualifiedVersion}" )

	LSDEBUG "Adding '${relPathToUpdateSite}' to composite repository '${streamPath}'"
	composite-repository \
		-location "${streamPath}" \
		-add "${relPathToUpdateSite}" \
		-repositoryName "${repoLabelPrefix} ${category} builds" \
		-compressed
		createP2Index "${streamPath}"

	LSDEBUG "Updating latest of stream '${stream}' @ '${streamPath}'"
	updateLatest "${streamPath}${streamPath:+/}${LATEST_FOLDER}" "${stream}" "${repoLabelPrefix} latest ${category} build"
}

publishUpdateSite() {
	local wd="${1}"
	local projectName="${2}"
	local category="${3}"
	local artifactURL="${4}"
	local qualifiedVersion="${5}"
	local home="${6}"

	unqualifiedVersion="$(echo ${qualifiedVersion} | sed-regex 's/^([0-9]+\.[0-9]+\.[0-9]+)\..+$/\1/')"
	LSDEBUG "unqualifiedVersion is '${unqualifiedVersion}'"
	minorVersion="$(echo ${qualifiedVersion} | sed-regex 's/^([0-9]+\.[0-9]+)\.[0-9]+\..+$/\1/')"
	LSDEBUG "Minor stream name is '${minorVersion}.x'"
	majorVersion="$(echo ${qualifiedVersion} | sed-regex 's/^([0-9]+)\.[0-9]+\.[0-9]+\..+$/\1/')"
	LSDEBUG "Major stream name is '${majorVersion}.x'"

	# the update site
	LSINFO "Downloading '${artifactURL}'"
	_retrieveZippedArtifact "${artifactURL}" "${wd}/update-site-${qualifiedVersion}.zip" "${wd}/update-site-${qualifiedVersion}"

	if [ ! -d "${home}/${qualifiedVersion}" ]; then
		LSDEBUG "Creating folder '${home}/${qualifiedVersion}'"
		mkdir -p "${home}/${qualifiedVersion}"
	fi

	LSINFO "Copying update site to '${home}/${qualifiedVersion}'"
	cp -Rf "${wd}/update-site/"* "${home}/${qualifiedVersion}"

	## streams update
	_publishUpdateSiteInStream "${projectName}" "${category}" "${home}" "${qualifiedVersion}" "${unqualifiedVersion}"
	_publishUpdateSiteInStream "${projectName}" "${category}" "${home}" "${qualifiedVersion}" "${minorVersion}"
	_publishUpdateSiteInStream "${projectName}" "${category}" "${home}" "${qualifiedVersion}" "${majorVersion}"
	_publishUpdateSiteInStream "${projectName}" "${category}" "${home}" "${qualifiedVersion}" ""
}
