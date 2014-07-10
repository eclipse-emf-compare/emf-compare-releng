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

[ -z "${UPDATE_SITE__ARTIFACT_URL}" -o -z "${UPDATE_SITE__ARTIFACT_NAME}" -o -z "${UPDATE_SITE__UNQUALIFIED_VERSION}" -o -z "${UPDATE_SITE__QUALIFIED_VERSION}" ] && {
     echo "Execution aborted.

One or more of the required variables is not set. They are normally
provided by the Hudson build.

- UPDATE_SITE__ARTIFACT_URL: the URL where the zipped update site to publish can be donwload.
- UPDATE_SITE__ARTIFACT_NAME: the filename of the zipped update site.
- UPDATE_SITE__UNQUALIFIED_VERSION: the unqualified version of the update site to publish.
- UPDATE_SITE__QUALIFIED_VERSION: the qualified version of the update site to publish.
"
    exit 1
}

source "$(dirname "${0}")/init.sh"

LSINFO "== Publishing nightly build '${PROJECT_NAME} ${UPDATE_SITE__QUALIFIED_VERSION}' == "

# the update site

for zip in *".zip"; do
	LSDEBUG "Removing previous zipped update site '${zip}'"
	rm -f ${zip}
done 

for folder in "${UPDATE_SITE__UNQUALIFIED_VERSION}"*; do
	LSDEBUG "Removing previous update site folder '${folder}'"
	rm -rf ${folder}
done

LSINFO "Downloading '${UPDATE_SITE__ARTIFACT_URL}'"
wget -q --no-check-certificate ${UPDATE_SITE__ARTIFACT_URL} -O - > ${UPDATE_SITE__ARTIFACT_NAME}

STREAM="$(echo ${UPDATE_SITE__UNQUALIFIED_VERSION} | sed-regex 's/^([0-9]+\.[0-9]+)\.[0-9]+$/\1/').x"
LSDEBUG "Stream name is '${STREAM}'"

LSINFO "Unziping '${UPDATE_SITE__ARTIFACT_NAME}'"
unzip -qq ${UPDATE_SITE__ARTIFACT_NAME} -d ${UPDATE_SITE__QUALIFIED_VERSION}

if [ ! -d "${UPDATE_NIGHTLY_HOME}" ]; then
	LSINFO "Creating folder '${UPDATE_NIGHTLY_HOME}'"
	mkdir -p ${UPDATE_NIGHTLY_HOME}
else
	LSDEBUG "Folder '${UPDATE_NIGHTLY_HOME}' already exists, do nothing"
fi
LSINFO "Copying update site to '${UPDATE_NIGHTLY_HOME}'"
cp -rf ${UPDATE_SITE__QUALIFIED_VERSION} ${UPDATE_NIGHTLY_HOME}

## stream update

LSINFO "Adding '../${UPDATE_SITE__QUALIFIED_VERSION}' to '${UPDATE_NIGHTLY_HOME}/${STREAM}'"
composite-repository \
	-location "${UPDATE_NIGHTLY_HOME}/${STREAM}" \
	-add "../${UPDATE_SITE__QUALIFIED_VERSION}" \
	-repositoryName "${PROJECT_NAME} ${STREAM} nightly builds" \
	-compressed
createP2Index "${UPDATE_NIGHTLY_HOME}/${STREAM}"

updateLatest "${UPDATE_NIGHTLY_HOME}/${STREAM}/latest" "${UPDATE_SITE__UNQUALIFIED_VERSION}" "../.." "${PROJECT_NAME} ${STREAM} latest nightly build"

LSINFO "Adding '${UPDATE_SITE__QUALIFIED_VERSION}' to '${UPDATE_NIGHTLY_HOME}'"
composite-repository \
	-location "${UPDATE_NIGHTLY_HOME}" \
	-add "${UPDATE_SITE__QUALIFIED_VERSION}" \
	-repositoryName "${PROJECT_NAME} nightly builds" \
	-compressed
createP2Index "${UPDATE_NIGHTLY_HOME}"

updateLatest "${UPDATE_NIGHTLY_HOME}/latest" "" ".." "${PROJECT_NAME} latest nightly build"

LSINFO "== '${PROJECT_NAME} ${UPDATE_SITE__QUALIFIED_VERSION}' has been published @ '${UPDATE_NIGHTLY_URL}/${UPDATE_SITE__QUALIFIED_VERSION}' == "

# the javadoc

# the documentation
