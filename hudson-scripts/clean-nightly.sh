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

LSINFO "== Clean up '${unqualifiedVersion}' nightly builds (will keep the ${nbBuildToKeep} most recent) =="

cleanUpdateSites "${UPDATE_NIGHTLY_HOME}" "${UPDATE_NIGHTLY_URL}" "${PROJECT_NAME}" "${NIGHTLY_FOLDER}" "${unqualifiedVersion}" "${nbBuildToKeep}"