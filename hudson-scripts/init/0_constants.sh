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

# Project specific
export PROJECT_NAME="EMF Compare"
__DOWNLOAD_PATH="download.eclipse.org/modeling/emf/compare"
__ECLIPSE_DOCUMENT_ROOT="/home/data/httpd"

# Private constants
__UPDATE_FOLDER="updates"
__NIGHTLY_FOLDER="nightly"
__INTEGRATION_FOLDER="integration"
__RELEASES_FOLDER="releases"
__SIMREL_FOLDER="simrel"
__STAGING_FOLDER="${__SIMREL_FOLDER}/staging"
__MAINTENANCE_FOLDER="${__SIMREL_FOLDER}/maintenance"
__MILESTONES_FOLDER="${__SIMREL_FOLDER}/milestones"

export DOWNLOAD_HOME="${__ECLIPSE_DOCUMENT_ROOT}/${__DOWNLOAD_PATH}"
export DOWNLOAD_URL="http://${__DOWNLOAD_PATH}"

# Computed from above
export UPDATE_PATH="${__DOWNLOAD_PATH}/${__UPDATE_FOLDER}"
export UPDATE_HOME="${DOWNLOAD_HOME}/${__UPDATE_FOLDER}"
export UPDATE_URL="${DOWNLOAD_URL}/${__UPDATE_FOLDER}"

export UPDATE_NIGHTLY_PATH="${UPDATE_PATH}/${__NIGHTLY_FOLDER}"
export UPDATE_NIGHTLY_HOME="${UPDATE_HOME}/${__NIGHTLY_FOLDER}"
export UPDATE_NIGHTLY_URL="${UPDATE_URL}/${__NIGHTLY_FOLDER}"

export UPDATE_INTEGRATION_PATH="${UPDATE_PATH}/${__INTEGRATION_FOLDER}"
export UPDATE_INTEGRATION_HOME="${UPDATE_HOME}/${__INTEGRATION_FOLDER}"
export UPDATE_INTEGRATION_URL="${UPDATE_URL}/${__INTEGRATION_FOLDER}"

export UPDATE_RELEASES_PATH="${UPDATE_PATH}/${__RELEASES_FOLDER}"
export UPDATE_RELEASES_HOME="${UPDATE_HOME}/${__RELEASES_FOLDER}"
export UPDATE_RELEASES_URL="${UPDATE_URL}/${__RELEASES_FOLDER}"

export UPDATE_STAGING_PATH="${UPDATE_PATH}/${__STAGING_FOLDER}"
export UPDATE_STAGING_HOME="${UPDATE_HOME}/${__STAGING_FOLDER}"
export UPDATE_STAGING_URL="${UPDATE_URL}/${__STAGING_FOLDER}"

export UPDATE_MAINTENANCE_PATH="${UPDATE_PATH}/${__MAINTENANCE_FOLDER}"
export UPDATE_MAINTENANCE_HOME="${UPDATE_HOME}/${__MAINTENANCE_FOLDER}"
export UPDATE_MAINTENANCE_URL="${UPDATE_URL}/${__MAINTENANCE_FOLDER}"

export UPDATE_MILESTONES_PATH="${UPDATE_PATH}/${__MILESTONES_FOLDER}"
export UPDATE_MILESTONES_HOME="${UPDATE_HOME}/${__MILESTONES_FOLDER}"
export UPDATE_MILESTONES_URL="${UPDATE_URL}/${__MILESTONES_FOLDER}"
