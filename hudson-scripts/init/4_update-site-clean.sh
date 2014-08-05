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
    local streamName="${3}"
    local updateSiteToClean="${4}"
    
    local _streamAbsolutePath=$( streamAbsolutePath "${updateHome}" "${streamName}" )
    local relpath=$( relativize "${_streamAbsolutePath}" "${updateHome}/${updateSiteToClean}" )

    LSDEBUG "Removing '${relpath}' from '${_streamAbsolutePath}'"
    compositeRepository -location "${_streamAbsolutePath}" -remove "${relpath}"
    
    ##check the number of children in streamPath, if 0 remove folder (no need to check latest)
    local streamPathChildren=( $(compositeRepository -location "${_streamAbsolutePath}" -list) )
    if [ ${#streamPathChildren[@]} -eq 0 ]; then
        LSINFO "Removing folder '${_streamAbsolutePath}' as it has no children anymore"
        if [ "${_streamAbsolutePath}" = "${updateHome}" ]; then
            # do not remove home
            rm -rf "${_streamAbsolutePath}/"*
        else
            rm -rf "${_streamAbsolutePath}"
        fi
    else
        local latestInStreamPath=$( streamLatestAbsolutePath "${updateHome}" "${streamName}" )
        local latestUpdateSiteInStream=( $(compositeRepository -location "${latestInStreamPath}" -list) )
        LSDEBUG "Current latest update site in stream '${_streamAbsolutePath}' is '${latestUpdateSiteInStream[@]}'"
        if [ ${#latestUpdateSiteInStream[@]} -gt 0 ]; then
            local updateSiteURLToClean="${updateURL}/${updateSiteToClean}"
            if [ ${#latestUpdateSiteInStream[@]} -gt 1 ]; then
                LSDEBUG "There are more than a single update site referenced in the repository ${latestInStreamPath}"
                compositeRepository -location "${latestInStreamPath}" -removeAll
                compositeRepository -location "${latestInStreamPath}" -add "${relpath}"
            elif [ "${updateSiteURLToClean}" = "${latestUpdateSiteInStream[0]}" ]; then
                relpath=$( relativize ${latestInStreamPath} ${updateHome}/${updateSiteToClean} )
                LSDEBUG "Removing '${relpath}' from '${latestInStreamPath}'"
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
        LSINFO "No build '${unqualifiedVersion}' found in '${updateHome}', nothing to clean'"
        exit 0
    fi

    if [ ${nbBuildToKeep} -gt 0 ]; then
        local updateSiteToKeep=( $(echo ${foldersWithUnqualifiedVersionPrefix[@]} | tr ' ' '\n' | sort -r | head -n ${nbBuildToKeep}) )
        local union=( ${updateSiteToKeep[@]} ${foldersWithUnqualifiedVersionPrefix[@]} )
        local updateSitesToClean=( $(echo ${union[@]} | tr ' ' '\n' | sort | uniq -u) )
    else
        local updateSitesToClean=( $(echo ${foldersWithUnqualifiedVersionPrefix[@]} | tr ' ' '\n' | sort) )
    fi

    if [ ${#updateSitesToClean[@]} -eq 0 ]; then
        LSINFO "There are ${#foldersWithUnqualifiedVersionPrefix[@]} '${unqualifiedVersion}' builds, nothing to clean as we are keeping the ${nbBuildToKeep} most recent builds."
    else
        local _minorVersion="$(minorVersion ${unqualifiedVersion})"
        local _majorVersion="$(majorVersion ${unqualifiedVersion})"

        for updateSiteToClean in ${updateSitesToClean[@]}; do
            LSINFO "Removing ${category} build '${updateSiteToClean}' from stream '$(streamLabel "${unqualifiedVersion}")'"
            _cleanNightly "${updateHome}" "${updateURL}" "${unqualifiedVersion}" "${updateSiteToClean}"
            
            LSINFO "Removing ${category} build '${updateSiteToClean}' from stream '$(streamLabel "${_minorVersion}")'"
            _cleanNightly "${updateHome}" "${updateURL}" "${_minorVersion}"      "${updateSiteToClean}"
            
            LSINFO "Removing ${category} build '${updateSiteToClean}' from stream '$(streamLabel "${_majorVersion}")'"
            _cleanNightly "${updateHome}" "${updateURL}" "${_majorVersion}"      "${updateSiteToClean}"
            
            LSINFO "Removing ${category} build '${updateSiteToClean}' from global stream"
            _cleanNightly "${updateHome}" "${updateURL}" ""                      "${updateSiteToClean}"

            LSDEBUG "Removing folder '${updateHome}/${updateSiteToClean}'"
            rm -rf "${updateHome}/${updateSiteToClean}"
        done

        LSINFO "Updating latest link of ${category} stream '$(streamLabel "${unqualifiedVersion}")'"
        _updateLatestUpdateSite "${updateHome}" "${unqualifiedVersion}" $(streamLatestRepositoryLabel "${projectName}" "${category}" "${unqualifiedVersion}")

        LSINFO "Updating latest link of ${category} stream '$(streamLabel "${_minorVersion}")'"
        _updateLatestUpdateSite "${updateHome}" "${_minorVersion}"      $(streamLatestRepositoryLabel "${projectName}" "${category}" "${_minorVersion}")

        LSINFO "Updating latest link of ${category} stream '$(streamLabel "${_majorVersion}")'"
        _updateLatestUpdateSite "${updateHome}" "${_majorVersion}"      $(streamLatestRepositoryLabel "${projectName}" "${category}" "${_majorVersion}")

        LSINFO "Updating latest link of ${category} global stream"
        _updateLatestUpdateSite "${updateHome}" ""                      $(streamLatestRepositoryLabel "${projectName}" "${category}" "")
    fi
}
