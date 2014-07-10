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

[  -z "${UPDATE_SITE__UNQUALIFIED_VERSION}" ] && {
    echo "Execution aborted.

One or more of the required variables is not set. They are normally
provided by the Hudson build.

 - UPDATE_SITE__UNQUALIFIED_VERSION: the unqualified version of the update site to publish.
"
    exit 1
}

source "$(dirname "${0}")/init.sh"

NB_BUILDS_TO_KEEP=${NB_BUILDS_TO_KEEP:-"5"}

CURRENT_PWD=$(pwd)

STREAM="$(echo ${UPDATE_SITE__UNQUALIFIED_VERSION} | sed-regex 's/^([0-9]+\.[0-9]+)\.[0-9]+$/\1/').x"
LSDEBUG "Stream name is '${STREAM}'"

LSINFO "Clean up nightly builds (will keep the ${NB_BUILDS_TO_KEEP} most recent builds of stream ${STREAM}')"

shopt -s nullglob

cd ${UPDATE_NIGHTLY_HOME}
ALL_FOLDERS_WITH_UNQUALIFIED_VERSION_PREFIX=( ${UPDATE_SITE__UNQUALIFIED_VERSION}* )
cd ${CURRENT_PWD}

if [ ${#ALL_FOLDERS_WITH_UNQUALIFIED_VERSION_PREFIX[@]} -eq 0 ]; then
    LSINFO "No build found for stream '${STREAM}' in '${UPDATE_NIGHTLY_HOME}'"
    exit 0
fi

if [ ${NB_BUILDS_TO_KEEP} -gt 0 ]; then
    UPDATE_SITE_TO_KEEP=( $(echo ${ALL_FOLDERS_WITH_UNQUALIFIED_VERSION_PREFIX[@]} | tr ' ' '\n' | sort -r | head -n ${NB_BUILDS_TO_KEEP}) )
    UNION=( ${UPDATE_SITE_TO_KEEP[@]} ${ALL_FOLDERS_WITH_UNQUALIFIED_VERSION_PREFIX[@]} )
    UPDATE_SITES__TO_CLEAN=( $(echo ${UNION[@]} | tr ' ' '\n' | sort | uniq -u) )
else
    UPDATE_SITES__TO_CLEAN=( $(echo ${ALL_FOLDERS_WITH_UNQUALIFIED_VERSION_PREFIX[@]} | tr ' ' '\n' | sort) )
fi

if [ ${#UPDATE_SITES__TO_CLEAN[@]} -eq 0 ]; then
    LSINFO "No build to clean for stream ${STREAM} (there are '${NB_BUILDS_TO_KEEP}' or less builds in this stream in '${UPDATE_NIGHTLY_HOME}'"
else
    LATEST_UPDATE_SITE__IN_STREAM=( $(composite-repository -location "${UPDATE_NIGHTLY_HOME}/${STREAM}/latest" -list) )
    LSDEBUG "Current latest update site in stream '${STREAM}' is '${LATEST_UPDATE_SITE__IN_STREAM[@]}'"

    LATEST_UPDATE_SITE__ALL_NIGHTLIES=( $(composite-repository -location "${UPDATE_NIGHTLY_HOME}/latest" -list) )
    LSDEBUG "Current latest update site is '${LATEST_UPDATE_SITE__ALL_NIGHTLIES[@]}'"

    for UPDATE_SITE__TO_CLEAN in ${UPDATE_SITES__TO_CLEAN[@]}
    do
        UPDATE_SITE_URL__TO_CLEAN="${UPDATE_NIGHTLY_URL}/${UPDATE_SITE__TO_CLEAN}"
        LSINFO "Removing '${UPDATE_SITE__TO_CLEAN}' from '${UPDATE_NIGHTLY_HOME}/${STREAM}'"
        composite-repository -location "${UPDATE_NIGHTLY_HOME}/${STREAM}" -remove "${UPDATE_SITE_URL__TO_CLEAN}"
        
        LSINFO "Removing '${UPDATE_SITE__TO_CLEAN}' from '${UPDATE_NIGHTLY_HOME}'"
        composite-repository -location "${UPDATE_NIGHTLY_HOME}" -remove "${UPDATE_SITE_URL__TO_CLEAN}"

        if [ ${#LATEST_UPDATE_SITE__IN_STREAM[@]} -gt 0 ]; then
            if [ ${#LATEST_UPDATE_SITE__IN_STREAM[@]} -gt 1 ]; then
                LSCRITICAL "There are more than a single update site referenced in the repository ${UPDATE_NIGHTLY_HOME}/${STREAM}/latest"
                exit 1
            elif [ "${UPDATE_SITE_URL__TO_CLEAN}" = "${LATEST_UPDATE_SITE__IN_STREAM[0]}" ]; then
                LSINFO "Removing '${UPDATE_SITE__TO_CLEAN}' from '${UPDATE_NIGHTLY_HOME}/${STREAM}/latest'"
                composite-repository -location "${UPDATE_NIGHTLY_HOME}/${STREAM}/latest" -remove "${UPDATE_SITE_URL__TO_CLEAN}"
            fi
        fi

        if [ ${#LATEST_UPDATE_SITE__ALL_NIGHTLIES[@]} -gt 0 ]; then
            if [ ${#LATEST_UPDATE_SITE__ALL_NIGHTLIES[@]} -gt 1 ]; then
                LSCRITICAL "There are more than a single update site referenced in the repository ${UPDATE_NIGHTLY_HOME}/latest"
                exit 1
            elif [ "${UPDATE_SITE_URL__TO_CLEAN}" = "${LATEST_UPDATE_SITE__ALL_NIGHTLIES[0]}" ]; then
                LSINFO "Removing '${UPDATE_SITE__TO_CLEAN}' from '${UPDATE_NIGHTLY_HOME}/latest'"
                composite-repository -location "${UPDATE_NIGHTLY_HOME}/latest" -remove "${UPDATE_SITE_URL__TO_CLEAN}"
            fi
        fi

        LSINFO "Removing folder '${UPDATE_NIGHTLY_HOME}/${UPDATE_SITE__TO_CLEAN}'"
        rm -rf "${UPDATE_NIGHTLY_HOME}/${UPDATE_SITE__TO_CLEAN}"
    done

    LATEST_UPDATE_SITE__IN_STREAM=( $(composite-repository -location "${UPDATE_NIGHTLY_HOME}/${STREAM}/latest" -list) )
    if [ ${#LATEST_UPDATE_SITE__IN_STREAM[@]} -eq 0 ]; then
        cd ${UPDATE_NIGHTLY_HOME}
        ALL_FILES_IN_STREAM=( $(echo "${UPDATE_SITE__UNQUALIFIED_VERSION}")* )
        cd ${CURRENT_PWD}
        if [ ${#ALL_FILES_IN_STREAM[@]} -gt 0 ]; then
            LASTEST_UPDATE_SITE=$( echo ${ALL_FILES_IN_STREAM[@]} | tr ' ' '\n' | sort | tail -n 1 )
            LSINFO "Redirecting '${UPDATE_NIGHTLY_HOME}/${STREAM}/latest' to '${UPDATE_NIGHTLY_URL}/${LASTEST_UPDATE_SITE}"
            createRedirect "${UPDATE_NIGHTLY_HOME}/${STREAM}/latest" "${UPDATE_NIGHTLY_URL}/${LASTEST_UPDATE_SITE}" "${PROJECT_NAME} ${STREAM} latest nightly build"
        else
            LSINFO "There is no more builds in '${STREAM}', removing folder '${UPDATE_NIGHTLY_HOME}/${STREAM}'"
            rm -rf "${UPDATE_NIGHTLY_HOME}/${STREAM}"
        fi
    else 
        LSDEBUG "After clean up, latest update site in stream '${STREAM}' is '${LATEST_UPDATE_SITE__IN_STREAM[@]}'"
    fi

    LATEST_UPDATE_SITE__ALL_NIGHTLIES=( $(composite-repository -location "${UPDATE_NIGHTLY_HOME}/latest" -list) )
    if [ ${#LATEST_UPDATE_SITE__ALL_NIGHTLIES[@]} -eq 0 ]; then
        cd ${UPDATE_NIGHTLY_HOME}
        ALL_FILES=( $(echo * | tr ' ' '\n' | grep -E '[0-9]+\.[0-9]+\.[0-9]+.*' || true) )
        cd ${CURRENT_PWD}
        if [ ${#ALL_FILES[@]} -gt 0 ]; then
            LASTEST_UPDATE_SITE=$( echo ${ALL_FILES[@]} | tr ' ' '\n' | sort | tail -n 1 )
            LSINFO "Redirecting '${UPDATE_NIGHTLY_HOME}/latest' to '${UPDATE_NIGHTLY_URL}/${LASTEST_UPDATE_SITE}"
            createRedirect "${UPDATE_NIGHTLY_HOME}/latest" "${UPDATE_NIGHTLY_URL}/${LASTEST_UPDATE_SITE}" "${PROJECT_NAME} latest nightly build"
        else
            LSINFO "There is no nightly builds in '${UPDATE_NIGHTLY_HOME}'"
            LSDEBUG "Removing all files from '${UPDATE_NIGHTLY_HOME}'"
            rm -rf "${UPDATE_NIGHTLY_HOME}/"*
        fi
    else
        LSDEBUG "After clean up, latest update site confounded is '${LATEST_UPDATE_SITE__ALL_NIGHTLIES[@]}'"
    fi
fi

shopt -u nullglob
