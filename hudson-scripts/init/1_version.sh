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

_QUALIFIED_VERSION_PATTERN="^([0-9]+)(\.([0-9]+)(\.([0-9]+)(\.(.+))?)?)?$"

unqualifiedVersion() {
	local qualifiedVersion="${1}"
	local v=$(echo ${qualifiedVersion} | sed-regex "s/${_QUALIFIED_VERSION_PATTERN}/\1.\3.\5/")
	echo "${v}"
}

minorVersion() {
	local qualifiedVersion="${1}"
	local v=$(echo ${qualifiedVersion} | sed-regex "s/${_QUALIFIED_VERSION_PATTERN}/\1.\3/")
	echo "${v}"
}

majorVersion() {
	local qualifiedVersion="${1}"
	local v=$(echo ${qualifiedVersion} | sed-regex "s/${_QUALIFIED_VERSION_PATTERN}/\1/")
	echo "${v}"
}
