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

streamPath() {
	local streamName="${1}"

	echo "${streamName:+${STREAMS_FOLDER}/${streamName}${STREAM_NAME_SUFFIX}}"
}

streamAbsolutePath() {
	local home="${1}"
	local streamName="${2}"

	local _streamPath="$(streamPath "${streamName}")"
	echo "${home}${_streamPath:+/${_streamPath}}"
}

streamLatestPath() {
	local streamName="${1}"

	local _streamPath="$(streamPath "${streamName}")"
	echo "${_streamPath:+${_streamPath}/}${LATEST_FOLDER}"
}

streamLatestAbsolutePath() {
	local home="${1}"
	local streamName="${2}"

	echo "${home}/$(streamLatestPath "${streamName}")"
}