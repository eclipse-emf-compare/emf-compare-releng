#!/bin/sh
# ====================================================================
# Copyright (c) 2015 Obeo
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
#
# Contributors:
#    Obeo - initial API and implementation
# ====================================================================

if [ $# -ne 4 ]; then
     echo "Execution aborted. One or more of the required parameters is not set. 

Usage: $0 egitLogicalArtifactURL egitLogicalQualifiedVersion emfCompareLogicalArtifactURL emfCompareLogicalQualifiedVersion


- egitLogicalArtifactURL: the URL where the zipped EGit Logical update site to publish can be donwload.
- egitLogicalQualifiedVersion: the qualified version of the EGit Logical update site to publish.
- emfCompareLogicalArtifactURL: the URL where the zipped EMF Compare on EGit Logical update site to publish can be donwload.
- emfCompareLogicalQualifiedVersion: the qualified version of the EMF Compare on EGit Logical update site to publish.
"
exit 1
fi

egitLogicalArtifactURL="${1}"
egitLogicalQualifiedVersion="${2}"
emfCompareLogicalArtifactURL="${3}"
emfCompareLogicalQualifiedVersion="${4}"

source "$(dirname "${0}")/init.sh"

LSINFO "Publishing integration build 'EGit Logical ${egitLogicalQualifiedVersion}'"

publishUpdateSite \
	"${WORKING_DIRECTORY}" \
	"${UPDATE_HOME}/egit-logical/${INTEGRATION_FOLDER}" \
	"EGit" \
	"${INTEGRATION_FOLDER}" \
	"${egitLogicalArtifactURL}" \
	"${egitLogicalQualifiedVersion}"

LSINFO "'EGit Logical ${egitLogicalQualifiedVersion}' has been published at '${UPDATE_URL}/egit-logical/${INTEGRATION_FOLDER}/${egitLogicalQualifiedVersion}'"

LSINFO "Publishing integration build 'EMF Compare on EGit Logical ${emfCompareLogicalQualifiedVersion}'"

publishUpdateSite \
	"${WORKING_DIRECTORY}" \
	"${UPDATE_HOME}/logical/emf.compare/${INTEGRATION_FOLDER}" \
	"EMF Compare" \
	"${INTEGRATION_FOLDER}" \
	"${emfCompareLogicalArtifactURL}" \
	"${emfCompareLogicalQualifiedVersion}"

LSINFO "'EMF Compare on EGit Logical ${emfCompareLogicalQualifiedVersion}' has been published at '${UPDATE_URL}/logical/emf.compare/${INTEGRATION_FOLDER}/${emfCompareLogicalQualifiedVersion}'"
