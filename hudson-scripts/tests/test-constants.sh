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

TEST_NAME="${TEST_NAME:-missingTestName}"

# Test specific constants
export WORKING_DIRECTORY="$(pwd)/target/tests/${TEST_NAME}"

export PROJECT_NAME="Test Project"
export DOWNLOAD_PATH="download.path"
export ECLIPSE_DOCUMENT_ROOT="${WORKING_DIRECTORY}/documentRoot"
export DOWNLOAD_URL="file:${ECLIPSE_DOCUMENT_ROOT}/${DOWNLOAD_PATH}"

export SCRIPT_PATH="$(dirname "${0}")"
export INIT_PATH="${SCRIPT_PATH}/../init"