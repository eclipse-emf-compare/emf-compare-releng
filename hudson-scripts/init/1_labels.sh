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

streamRepositoryLabel() {
	local projectName="${1}"
	local category="${2}"
	local streamName="${3}"

	echo "${projectName}${streamName:+ ${streamName}${STREAM_NAME_SUFFIX}} ${category} builds"
}

streamLatestRepositoryLabel() {
	local projectName="${1}"
	local category="${2}"
	local streamName="${3}"

	echo "${projectName}${streamName:+ ${streamName}${STREAM_NAME_SUFFIX}} latest ${category} build"
}

streamLabel() {
	local streamName="${1}"	

	echo "${streamName:+${streamName}${STREAM_NAME_SUFFIX}}"
}