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

if [ $# -ne 2 ]; then
     echo "Execution aborted. One or more of the required parameters is not set. 

Usage: $0 artifactURL unqualifiedVersion qualifiedVersion

- artifactURL: the URL where the zipped update site to publish can be donwload.
- qualifiedVersion: the qualified version of the update site to publish.
"
fi

artifactURL="${1}"
qualifiedVersion="${2}"

source "$(dirname "${0}")/init.sh"

LSINFO "== Publishing nightly build '${PROJECT_NAME} ${qualifiedVersion}' == "

publishUpdateSite "${WORKING_DIRECTORY}" "${PROJECT_NAME}" "${NIGHTLY_FOLDER}" "${artifactURL}" "${qualifiedVersion}" "${UPDATE_NIGHTLY_HOME}"

LSINFO "== '${PROJECT_NAME} ${qualifiedVersion}' has been published @ '${UPDATE_NIGHTLY_URL}/${qualifiedVersion}' == "
