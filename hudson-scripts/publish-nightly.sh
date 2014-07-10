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

[ -z "${GIT_BRANCH}" -o -z "${UPDATE_SITE__ARTIFACT_URL}" -o -z "${UPDATE_SITE__ARTIFACT_NAME}" -o -z "${UPDATE_SITE__UNQUALIFIED_VERSION}" -o -z "${UPDATE_SITE__QUALIFIED_VERSION}" ] && {
     echo "Execution aborted.

One or more of the required variables is not set. They are normally
provided by the Hudson build.

- GIT_BRANCH: the git branch that has been build. 
- UPDATE_SITE__ARTIFACT_URL: the URL where the zipped update site to publish can be donwload.
- UPDATE_SITE__ARTIFACT_NAME: the filename of the zipped update site.
- UPDATE_SITE__UNQUALIFIED_VERSION: the unqualified version of the update site to publish.
- UPDATE_SITE__QUALIFIED_VERSION: the qualified version of the update site to publish.
"
    exit 1
}

source "$(dirname "${0}")/init.sh"

LSINFO "Publishing nightly build (${UPDATE_SITE__QUALIFIED_VERSION}) of ${PROJECT_NAME}"

# the update site

for zip in *.zip;
do
	LSDEBUG "Removing previous zipped update site '${zip}'"
	rm -f ${zip}
done 

LSINFO "Downloading '${UPDATE_SITE__ARTIFACT_URL}'"
wget -q --no-check-certificate ${UPDATE_SITE__ARTIFACT_URL} -O - > ${UPDATE_SITE__ARTIFACT_NAME}

STREAM="$(echo ${UPDATE_SITE__UNQUALIFIED_VERSION} | sed-regex 's/^([0-9]+\.[0-9]+)\.[0-9]+$/\1/').x"
LSDEBUG "Stream name is '${STREAM}'"

if [ -d ${UPDATE_SITE__QUALIFIED_VERSION} ];then
	LSDEBUG "Removing folder '${UPDATE_SITE__QUALIFIED_VERSION}'"
	rm -rf ${UPDATE_SITE__QUALIFIED_VERSION}
fi
LSDEBUG "Unziping '${UPDATE_SITE__ARTIFACT_NAME}'"
unzip -qq ${UPDATE_SITE__ARTIFACT_NAME} -d ${UPDATE_SITE__QUALIFIED_VERSION}

if [ ! -d ${UPDATE_NIGHTLY_HOME} ]; then
	LSDEBUG "Creating folder '${UPDATE_NIGHTLY_HOME}'"
	mkdir -p ${UPDATE_NIGHTLY_HOME}
fi
LSINFO "Copying update site to '${UPDATE_NIGHTLY_HOME}'"
cp -rf ${UPDATE_SITE__QUALIFIED_VERSION} ${UPDATE_NIGHTLY_HOME}

## stream update

LSINFO "Adding '${UPDATE_NIGHTLY_URL}/${UPDATE_SITE__QUALIFIED_VERSION}' to '${UPDATE_NIGHTLY_HOME}/${STREAM}'"
composite-repository \
	-location "${UPDATE_NIGHTLY_HOME}/${STREAM}" \
	-add "${UPDATE_NIGHTLY_URL}/${UPDATE_SITE__QUALIFIED_VERSION}" \
	-repositoryName "${PROJECT_NAME} ${STREAM} nightly builds" \
	-compressed
createP2Index "${UPDATE_NIGHTLY_HOME}/${STREAM}"

LSINFO "Creating redirection from '${UPDATE_NIGHTLY_HOME}/${STREAM}/latest' to '${UPDATE_NIGHTLY_URL}/${UPDATE_SITE__QUALIFIED_VERSION}'"
createRedirect "${UPDATE_NIGHTLY_HOME}/${STREAM}/latest" "${UPDATE_NIGHTLY_URL}/${UPDATE_SITE__QUALIFIED_VERSION}" "${PROJECT_NAME} ${STREAM} latest nightly build"

## all updates

LSINFO "Adding '${UPDATE_NIGHTLY_URL}/${UPDATE_SITE__QUALIFIED_VERSION}' to '${UPDATE_NIGHTLY_HOME}'"
composite-repository \
	-location "${UPDATE_NIGHTLY_HOME}" \
	-add "${UPDATE_NIGHTLY_URL}/${UPDATE_SITE__QUALIFIED_VERSION}" \
	-repositoryName "${PROJECT_NAME} nightly builds" \
	-compressed
createP2Index "${UPDATE_NIGHTLY_HOME}"

if [ ${GIT_BRANCH} = "master" ]; then
	LSINFO "On master branch, then create redirection from '${UPDATE_NIGHTLY_HOME}/latest' to '${UPDATE_NIGHTLY_URL}/${UPDATE_SITE__QUALIFIED_VERSION}'"
	createRedirect "${UPDATE_NIGHTLY_HOME}/latest" "${UPDATE_NIGHTLY_URL}/${UPDATE_SITE__QUALIFIED_VERSION}" "${PROJECT_NAME} latest nightly build"
fi

# the javadoc

# the documentation
