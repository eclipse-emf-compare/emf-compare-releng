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

if [ $# -lt 1 ]; then
     echo "Execution aborted. One or more of the required parameters is not set. 

Usage: $0 unqualifiedVersion [nbBuildToKeep]

- unqualifiedVersion: the unqualified version of the update sites to clean.
- nbBuildToKeep: the number of build to keep. 0 to remove all streams related to the unqualifiedVersion
"
exit 1
fi

unqualifiedVersion="${1}"
nbBuildToKeep="${2:-5}"

source "$(dirname "${0}")/init.sh"

currentPwd=$(pwd)

LSDEBUG "unqualifiedVersion is '${unqualifiedVersion}'"
minorVersion="$(echo ${unqualifiedVersion} | sed-regex 's/^([0-9]+\.[0-9]+)\.[0-9]+$/\1/')"
LSDEBUG "Minor stream name is '${minorVersion}.x'"
majorVersion="$(echo ${unqualifiedVersion} | sed-regex 's/^([0-9]+)\.[0-9]+\.[0-9]+$/\1/')"
LSDEBUG "Major stream name is '${majorVersion}.x'"

LSINFO "== Clean up '${unqualifiedVersion}' nightly builds (will keep the ${nbBuildToKeep} most recent) =="

cd "${UPDATE_NIGHTLY_HOME}"
foldersWithUnqualifiedVersionPrefix=( "${unqualifiedVersion}"* )
cd "${currentPwd}"

if [ ${#foldersWithUnqualifiedVersionPrefix[@]} -eq 0 ]; then
    LSINFO "No build '${unqualifiedVersion}' found in '${UPDATE_NIGHTLY_HOME}, nothing to clean'"
    exit 0
fi

if [ ${nbBuildToKeep} -gt 0 ]; then
    updateSiteToKeep=( $(echo ${foldersWithUnqualifiedVersionPrefix[@]} | tr ' ' '\n' | sort -r | head -n ${nbBuildToKeep}) )
    UNION=( ${updateSiteToKeep[@]} ${foldersWithUnqualifiedVersionPrefix[@]} )
    updateSitesToClean=( $(echo ${UNION[@]} | tr ' ' '\n' | sort | uniq -u) )
else
    updateSitesToClean=( $(echo ${foldersWithUnqualifiedVersionPrefix[@]} | tr ' ' '\n' | sort) )
fi

if [ ${#updateSitesToClean[@]} -eq 0 ]; then
    LSINFO "There are ${#foldersWithUnqualifiedVersionPrefix[@]} '${unqualifiedVersion}' builds, nothing to clean as we are keeping the ${nbBuildToKeep} most recent builds."
else
    for updateSiteToClean in ${updateSitesToClean[@]}; do
        cleanNightly ${updateSiteToClean} "${UPDATE_NIGHTLY_HOME}/streams/${unqualifiedVersion}.x" "${UPDATE_NIGHTLY_HOME}/streams/${unqualifiedVersion}.x/latest"
        cleanNightly ${updateSiteToClean} "${UPDATE_NIGHTLY_HOME}/streams/${minorVersion}.x"       "${UPDATE_NIGHTLY_HOME}/streams/${minorVersion}.x/latest"
        cleanNightly ${updateSiteToClean} "${UPDATE_NIGHTLY_HOME}/streams/${majorVersion}.x"       "${UPDATE_NIGHTLY_HOME}/streams/${majorVersion}.x/latest"
        cleanNightly ${updateSiteToClean} "${UPDATE_NIGHTLY_HOME}"                                 "${UPDATE_NIGHTLY_HOME}/latest"

        LSINFO "Removing folder '${UPDATE_NIGHTLY_HOME}/${updateSiteToClean}'"
        rm -rf "${UPDATE_NIGHTLY_HOME}/${updateSiteToClean}"
    done

    updateLatest "${UPDATE_NIGHTLY_HOME}/streams/${unqualifiedVersion}.x/latest" "${UPDATE_NIGHTLY_HOME}" "${unqualifiedVersion}" "${PROJECT_NAME} ${unqualifiedVersion}.x latest nightly build"
    updateLatest "${UPDATE_NIGHTLY_HOME}/streams/${minorVersion}.x/latest"       "${UPDATE_NIGHTLY_HOME}" "${minorVersion}"       "${PROJECT_NAME} ${minorVersion}.x latest nightly build"
    updateLatest "${UPDATE_NIGHTLY_HOME}/streams/${majorVersion}.x/latest"       "${UPDATE_NIGHTLY_HOME}" "${majorVersion}"       "${PROJECT_NAME} ${majorVersion}.x latest nightly build"
    updateLatest "${UPDATE_NIGHTLY_HOME}/latest"                                 "${UPDATE_NIGHTLY_HOME}" ""                      "${PROJECT_NAME} latest nightly build"

fi
