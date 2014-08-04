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

updateLatest() {
    local absolutePathToLatest="${1}"
    local updateHome="${2}"
    local prefix="${3}"
    local latestRepoName="${4}"

    local currentPwd=$(pwd)
    cd "${updateHome}"
    local allFilesWithPrefix=( $(echo "${prefix}"* | tr ' ' '\n' | grep -E '[0-9]+\.[0-9]+\.[0-9]+.*' || true) )    
    cd "${currentPwd}"

    if [ ${#allFilesWithPrefix[@]} -gt 0 ]; then
        local latestUpdatePath=$( echo ${allFilesWithPrefix[@]} | tr ' ' '\n' | sort | tail -n 1 )
        local relpath=$( relativize ${absolutePathToLatest} ${updateHome}/${latestUpdatePath} )
        LSINFO "Creating redirection from '${absolutePathToLatest}' to '${latestUpdatePath}'" 
        createRedirect "${absolutePathToLatest}" "${relpath}" "${latestRepoName}"        
    else
        LSDEBUG "There is no folder that seem to be an update site in '${updateHome}'. No one have a name that start with '${prefix}' and that match the regex '[0-9]+\.[0-9]+\.[0-9]+.*'"
    fi
}

cleanNightly() {
    local updateSiteToClean=$1
    local streamPath=$2
    local latestInStreamPath=$3

    local updateSiteURLToClean="${UPDATE_NIGHTLY_URL}/${updateSiteToClean}"
    local relpath=$( relativize ${streamPath} ${UPDATE_NIGHTLY_HOME}/${updateSiteToClean} )

    LSINFO "Removing '${relpath}' from '${streamPath}'"
    compositeRepository -location "${streamPath}" -remove "${relpath}"
    
    ##check the number of children in streamPath, if 0 remove folder (no need to check latest)
    local streamPathChild=( $(compositeRepository -location "${streamPath}" -list) )
    if [ ${#streamPathChild[@]} -eq 0 ]; then
        LSINFO "Removing folder '${streamPath}' as it has no children anymore"
        if [ "${streamPath}" = "${UPDATE_NIGHTLY_HOME}" ]; then
            rm -rf "${streamPath}/"*
        else
            rm -rf "${streamPath}"
        fi
    else
        local latestUpdateSiteInStream=( $(compositeRepository -location "${latestInStreamPath}" -list) )
        LSDEBUG "Current latest update site in stream '${streamPath}' is '${latestUpdateSiteInStream[@]}'"
        if [ ${#latestUpdateSiteInStream[@]} -gt 0 ]; then
            if [ ${#latestUpdateSiteInStream[@]} -gt 1 ]; then
                LSCRITICAL "There are more than a single update site referenced in the repository ${latestInStreamPath}"
                exit 1
            elif [ "${updateSiteURLToClean}" = "${latestUpdateSiteInStream[0]}" ]; then
                relpath=$( relativize ${latestInStreamPath} ${UPDATE_NIGHTLY_HOME}/${updateSiteToClean} )
                LSINFO "Removing '${relpath}' from '${latestInStreamPath}'"
                compositeRepository -location "${latestInStreamPath}" -remove "${relpath}"
            fi
        fi
    fi
}
