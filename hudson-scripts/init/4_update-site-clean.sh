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

_cleanNightly() {
    local updateHome="${1}"
    local updateURL="${2}"
    local streamPath="${3}"
    local updateSiteToClean="${4}"
    
    local latestInStreamPath="${streamPath}/${LATEST_FOLDER}"
    local updateSiteURLToClean="${updateURL}/${updateSiteToClean}"
    local relpath=$( relativize ${streamPath} ${updateHome}/${updateSiteToClean} )

    LSINFO "Removing '${relpath}' from '${streamPath}'"
    compositeRepository -location "${streamPath}" -remove "${relpath}"
    
    ##check the number of children in streamPath, if 0 remove folder (no need to check latest)
    local streamPathChild=( $(compositeRepository -location "${streamPath}" -list) )
    if [ ${#streamPathChild[@]} -eq 0 ]; then
        LSINFO "Removing folder '${streamPath}' as it has no children anymore"
        if [ "${streamPath}" = "${updateHome}" ]; then
            # do not remove home
            rm -rf "${streamPath}/"*
        else
            rm -rf "${streamPath}"
        fi
    else
        local latestUpdateSiteInStream=( $(compositeRepository -location "${latestInStreamPath}" -list) )
        LSDEBUG "Current latest update site in stream '${streamPath}' is '${latestUpdateSiteInStream[@]}'"
        if [ ${#latestUpdateSiteInStream[@]} -gt 0 ]; then
            if [ ${#latestUpdateSiteInStream[@]} -gt 1 ]; then
                LSDEBUG "There are more than a single update site referenced in the repository ${latestInStreamPath}"
                compositeRepository -location "${latestInStreamPath}" -removeAll
                compositeRepository -location "${latestInStreamPath}" -add "${relpath}"
            elif [ "${updateSiteURLToClean}" = "${latestUpdateSiteInStream[0]}" ]; then
                relpath=$( relativize ${latestInStreamPath} ${updateHome}/${updateSiteToClean} )
                LSINFO "Removing '${relpath}' from '${latestInStreamPath}'"
                compositeRepository -location "${latestInStreamPath}" -remove "${relpath}"
            fi
        fi
    fi
}

cleanUpdateSites() {
    local updateHome="${1}"
    local updateURL="${2}"
    local projectName="${3}"
    local category="${4}"
    local unqualifiedVersion="${5}"
    local nbBuildToKeep="${6:-5}"

    local currentPwd=$(pwd)
    cd "${updateHome}"
    local foldersWithUnqualifiedVersionPrefix=( "${unqualifiedVersion}"* )
    cd "${currentPwd}"

    if [ ${#foldersWithUnqualifiedVersionPrefix[@]} -eq 0 ]; then
        LSINFO "No build '${unqualifiedVersion}' found in '${updateHome}, nothing to clean'"
        exit 0
    fi

    if [ ${nbBuildToKeep} -gt 0 ]; then
        local updateSiteToKeep=( $(echo ${foldersWithUnqualifiedVersionPrefix[@]} | tr ' ' '\n' | sort -r | head -n ${nbBuildToKeep}) )
        local UNION=( ${updateSiteToKeep[@]} ${foldersWithUnqualifiedVersionPrefix[@]} )
        local updateSitesToClean=( $(echo ${UNION[@]} | tr ' ' '\n' | sort | uniq -u) )
    else
        local updateSitesToClean=( $(echo ${foldersWithUnqualifiedVersionPrefix[@]} | tr ' ' '\n' | sort) )
    fi

    if [ ${#updateSitesToClean[@]} -eq 0 ]; then
        LSINFO "There are ${#foldersWithUnqualifiedVersionPrefix[@]} '${unqualifiedVersion}' builds, nothing to clean as we are keeping the ${nbBuildToKeep} most recent builds."
    else
        local _minorVersion="$(minorVersion ${unqualifiedVersion})"
        local _majorVersion="$(majorVersion ${unqualifiedVersion})"

        for updateSiteToClean in ${updateSitesToClean[@]}; do
            _cleanNightly "${updateHome}" "${updateURL}" "${updateHome}/${STREAMS_FOLDER}/${unqualifiedVersion}${STREAM_NAME_SUFFIX}"  "${updateSiteToClean}"
            _cleanNightly "${updateHome}" "${updateURL}" "${updateHome}/${STREAMS_FOLDER}/${_minorVersion}${STREAM_NAME_SUFFIX}"       "${updateSiteToClean}"
            _cleanNightly "${updateHome}" "${updateURL}" "${updateHome}/${STREAMS_FOLDER}/${_majorVersion}${STREAM_NAME_SUFFIX}"       "${updateSiteToClean}"
            _cleanNightly "${updateHome}" "${updateURL}" "${updateHome}"                                                               "${updateSiteToClean}"

            LSINFO "Removing folder '${updateHome}/${updateSiteToClean}'"
            rm -rf "${updateHome}/${updateSiteToClean}"
        done

        _updateLatestUpdateSite "${updateHome}" "${updateHome}/${STREAMS_FOLDER}/${unqualifiedVersion}${STREAM_NAME_SUFFIX}/${LATEST_FOLDER}" "${unqualifiedVersion}" "${projectName} ${unqualifiedVersion}${STREAM_NAME_SUFFIX} latest ${category} build"
        _updateLatestUpdateSite "${updateHome}" "${updateHome}/${STREAMS_FOLDER}/${_minorVersion}${STREAM_NAME_SUFFIX}/${LATEST_FOLDER}"      "${_minorVersion}"      "${projectName} ${_minorVersion}${STREAM_NAME_SUFFIX} latest ${category} build"
        _updateLatestUpdateSite "${updateHome}" "${updateHome}/${STREAMS_FOLDER}/${_majorVersion}${STREAM_NAME_SUFFIX}/${LATEST_FOLDER}"      "${_majorVersion}"      "${projectName} ${_majorVersion}${STREAM_NAME_SUFFIX} latest ${category} build"
        _updateLatestUpdateSite "${updateHome}" "${updateHome}/${LATEST_FOLDER}"                                                              ""                      "${projectName} latest ${category} build"
    fi
}
