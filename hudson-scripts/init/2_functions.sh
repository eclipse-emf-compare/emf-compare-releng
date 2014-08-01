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
    local latestPath=$1
    local prefix=$2
    local latestRepoName=$3

    local currentPwd=$(pwd)
    cd ${UPDATE_NIGHTLY_HOME}
    local allFilesWithPrefix=( $(echo "${prefix}"* | tr ' ' '\n' | grep -E '[0-9]+\.[0-9]+\.[0-9]+.*' || true) )    
    cd ${currentPwd}

    if [ ${#allFilesWithPrefix[@]} -gt 0 ]; then
        local latestUpdatePath=$( echo ${allFilesWithPrefix[@]} | tr ' ' '\n' | sort | tail -n 1 )
        if [ ! -z "${latestUpdatePath}" ]; then
            local relpath=$( relativize ${latestPath} ${UPDATE_NIGHTLY_HOME}/${latestUpdatePath} )
            local latestUpdateSite_onDisk="file:${UPDATE_NIGHTLY_HOME}/${latestUpdatePath}"
            LSDEBUG "Latest update site on disk is '${latestUpdateSite_onDisk}'"
            if [ -d "${latestPath}" ]; then
                local latestUpdateSite_inRepo=( $(composite-repository -location "${latestPath}" -list) )
                if [ ${#latestUpdateSite_inRepo[@]} -gt 0 ]; then
                    LSDEBUG "Latest update site in '${latestPath}' is '${latestUpdateSite_inRepo[0]}'"
                    if [ "${latestUpdateSite_inRepo[0]}" != "${latestUpdateSite_onDisk}" ]; then
                        LSINFO "Creating redirection from '${latestPath}' to '${latestUpdatePath}'" 
                        createRedirect "${latestPath}" "${relpath}" "${latestRepoName}"
                    else
                        LSINFO "'${latestPath}' is already referencing the latest update site. Do nothing"
                    fi
                else
                    LSDEBUG "Latest update site in '${latestPath}' is empty"
                    LSINFO "Creating redirection from '${latestPath}' to '${latestUpdatePath}'" 
                    createRedirect "${latestPath}" "${relpath}" "${latestRepoName}"
                fi
            else # folder nightly/latest does not exist
                LSDEBUG "Folder '${latestPath}' does not exist, it will be created"
                LSINFO "Creating redirection from '${latestPath}' to '${latestUpdatePath}'" 
                createRedirect "${latestPath}" "${relpath}" "${latestRepoName}"
            fi
        else 
            LSERROR "Some files seems to be update site starting with '${prefix}' but we could not tail the list"
        fi
    else
        LSDEBUG "There is no folder that seem to be an update site in '${UPDATE_NIGHTLY_HOME}'. No one have a name that start with '${prefix}' and that match the regex '[0-9]+\.[0-9]+\.[0-9]+.*'"
    fi
}

cleanNightly() {
    local updateSiteToClean=$1
    local streamPath=$2
    local latestInStreamPath=$3

    local updateSiteURLToClean="${UPDATE_NIGHTLY_URL}/${updateSiteToClean}"
    local relpath=$( relativize ${streamPath} ${UPDATE_NIGHTLY_HOME}/${updateSiteToClean} )

    LSINFO "Removing '${relpath}' from '${streamPath}'"
    composite-repository -location "${streamPath}" -remove "${relpath}"
    
    ##check the number of children in streamPath, if 0 remove folder (no need to check latest)
    local streamPathChild=( $(composite-repository -location "${streamPath}" -list) )
    if [ ${#streamPathChild[@]} -eq 0 ]; then
        LSINFO "Removing folder '${streamPath}' as it has no children anymore"
        if [ "${streamPath}" = "${UPDATE_NIGHTLY_HOME}" ]; then
            rm -rf "${streamPath}/"*
        else
            rm -rf "${streamPath}"
        fi
    else
        local latestUpdateSiteInStream=( $(composite-repository -location "${latestInStreamPath}" -list) )
        LSDEBUG "Current latest update site in stream '${streamPath}' is '${latestUpdateSiteInStream[@]}'"
        if [ ${#latestUpdateSiteInStream[@]} -gt 0 ]; then
            if [ ${#latestUpdateSiteInStream[@]} -gt 1 ]; then
                LSCRITICAL "There are more than a single update site referenced in the repository ${latestInStreamPath}"
                exit 1
            elif [ "${updateSiteURLToClean}" = "${latestUpdateSiteInStream[0]}" ]; then
                relpath=$( relativize ${latestInStreamPath} ${UPDATE_NIGHTLY_HOME}/${updateSiteToClean} )
                LSINFO "Removing '${relpath}' from '${latestInStreamPath}'"
                composite-repository -location "${latestInStreamPath}" -remove "${relpath}"
            fi
        fi
    fi
}
