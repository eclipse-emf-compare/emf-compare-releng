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

# Test specific constants
export WORKING_DIRECTORY="$(pwd)/target"

export PROJECT_NAME="Test Project"
export DOWNLOAD_PATH="publisher"
export ECLIPSE_DOCUMENT_ROOT="${WORKING_DIRECTORY}/tests/documentRoot"
export DOWNLOAD_URL="file:${ECLIPSE_DOCUMENT_ROOT}/${DOWNLOAD_PATH}"

export SCRIPT_PATH="$(dirname "${0}")"
export INIT_PATH="${SCRIPT_PATH}/../init"

source "${SCRIPT_PATH}/../init.sh"
source "${SCRIPT_PATH}/test-utils.sh"

reports="${WORKING_DIRECTORY}/tests/results-publish-nightly.txt"
dummySite="file:$(pwd)/${SCRIPT_PATH}/data/dummy-site.zip"

test01() {
	LSTEST "Test publish-nightly 1.0.0.A"
	${SCRIPT_PATH}/../publish-nightly.sh "${dummySite}" "1.0.0.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}" "publish-nightly" "test01 all" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/latest" "publish-nightly" "test01 latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x" "publish-nightly" "test01 1.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x/latest" "publish-nightly" "test01 1.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x" "publish-nightly" "test01 1.0.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x/latest" "publish-nightly" "test01 1.0.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x" "publish-nightly" "test01 1.0.0.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x/latest" "publish-nightly" "test01 1.0.0.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A"
}

test02() {
	LSTEST "Test publish-nightly 1.0.0.B"
	${SCRIPT_PATH}/../publish-nightly.sh "${dummySite}" "1.0.0.B"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}" "publish-nightly" "test02 all" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/latest" "publish-nightly" "test02 latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x" "publish-nightly" "test02 1.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x/latest" "publish-nightly" "test02 1.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x" "publish-nightly" "test02 1.0.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x/latest" "publish-nightly" "test02 1.0.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x" "publish-nightly" "test02 1.0.0.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x/latest" "publish-nightly" "test02 1.0.0.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
}

test03() {
	LSTEST "Test publish-nightly 1.0.5.A"
	${SCRIPT_PATH}/../publish-nightly.sh "${dummySite}" "1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}" "publish-nightly" "test03 all" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/latest" "publish-nightly" "test03 latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x" "publish-nightly" "test03 1.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x/latest" "publish-nightly" "test03 1.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x" "publish-nightly" "test03 1.0.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x/latest" "publish-nightly" "test03 1.0.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x" "publish-nightly" "test03 1.0.0.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x/latest" "publish-nightly" "test03 1.0.0.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.5.x" "publish-nightly" "test03 1.0.5.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.5.x/latest" "publish-nightly" "test03 1.0.5.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
}

test04() {
	LSTEST "Test publish-nightly 1.4.5.M"
	${SCRIPT_PATH}/../publish-nightly.sh "${dummySite}" "1.4.5.M"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}" "publish-nightly" "test04 all" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.5.A" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/latest" "publish-nightly" "test04 latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x" "publish-nightly" "test04 1.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.5.A" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x/latest" "publish-nightly" "test04 1.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x" "publish-nightly" "test04 1.0.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x/latest" "publish-nightly" "test04 1.0.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x" "publish-nightly" "test04 1.0.0.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x/latest" "publish-nightly" "test04 1.0.0.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.5.x" "publish-nightly" "test04 1.0.5.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.5.x/latest" "publish-nightly" "test04 1.0.5.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.x" "publish-nightly" "test04 1.4.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M"	
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.x/latest" "publish-nightly" "test04 1.4.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.5.x" "publish-nightly" "test04 1.4.5.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M"	
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.5.x/latest" "publish-nightly" "test04 1.4.5.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M"
}

test05() {
	LSTEST "Test publish-nightly 1.2.8.P"
	${SCRIPT_PATH}/../publish-nightly.sh "${dummySite}" "1.2.8.P"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}" "publish-nightly" "test05 all" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.5.A" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M" "file:${UPDATE_NIGHTLY_HOME}/1.2.8.P"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/latest" "publish-nightly" "test05 latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x" "publish-nightly" "test05 1.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.5.A" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M" "file:${UPDATE_NIGHTLY_HOME}/1.2.8.P"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x/latest" "publish-nightly" "test05 1.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x" "publish-nightly" "test05 1.0.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x/latest" "publish-nightly" "test05 1.0.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x" "publish-nightly" "test05 1.0.0.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x/latest" "publish-nightly" "test05 1.0.0.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.5.x" "publish-nightly" "test05 1.0.5.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.5.x/latest" "publish-nightly" "test05 1.0.5.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.x" "publish-nightly" "test05 1.4.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M"	
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.x/latest" "publish-nightly" "test05 1.4.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.5.x" "publish-nightly" "test05 1.4.5.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M"	
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.5.x/latest" "publish-nightly" "test05 1.4.5.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.2.x" "publish-nightly" "test05 1.2.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.2.8.P"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.2.x/latest" "publish-nightly" "test05 1.2.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.2.8.P"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.2.8.x" "publish-nightly" "test05 1.2.8.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.2.8.P"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.2.8.x/latest" "publish-nightly" "test05 1.2.8.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.2.8.P"
}

test06() {
	LSTEST "Test publish-nightly 1.4.1.A"
	${SCRIPT_PATH}/../publish-nightly.sh "${dummySite}" "1.4.1.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}" "publish-nightly" "test06 all" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.5.A" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M" "file:${UPDATE_NIGHTLY_HOME}/1.2.8.P" "file:${UPDATE_NIGHTLY_HOME}/1.4.1.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/latest" "publish-nightly" "test06 latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x" "publish-nightly" "test06 1.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.5.A" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M" "file:${UPDATE_NIGHTLY_HOME}/1.2.8.P" "file:${UPDATE_NIGHTLY_HOME}/1.4.1.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x/latest" "publish-nightly" "test06 1.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x" "publish-nightly" "test06 1.0.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x/latest" "publish-nightly" "test06 1.0.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x" "publish-nightly" "test06 1.0.0.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x/latest" "publish-nightly" "test06 1.0.0.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.5.x" "publish-nightly" "test06 1.0.5.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.5.x/latest" "publish-nightly" "test06 1.0.5.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.x" "publish-nightly" "test06 1.4.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M" "file:${UPDATE_NIGHTLY_HOME}/1.4.1.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.x/latest" "publish-nightly" "test06 1.4.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.5.x" "publish-nightly" "test06 1.4.5.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M"	
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.5.x/latest" "publish-nightly" "test06 1.4.5.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.2.x" "publish-nightly" "test06 1.2.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.2.8.P"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.2.x/latest" "publish-nightly" "test06 1.2.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.2.8.P"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.2.8.x" "publish-nightly" "test06 1.2.8.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.2.8.P"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.2.8.x/latest" "publish-nightly" "test06 1.2.8.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.2.8.P"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.1.x" "publish-nightly" "test06 1.4.1.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.1.A"	
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.1.x/latest" "publish-nightly" "test06 1.4.1..x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.1.A"
}

test07() {
	LSTEST "Test publish-nightly 3.5.25.G"
	${SCRIPT_PATH}/../publish-nightly.sh "${dummySite}" "3.5.25.G"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}" "publish-nightly" "test07 all" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.5.A" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M" "file:${UPDATE_NIGHTLY_HOME}/1.2.8.P" "file:${UPDATE_NIGHTLY_HOME}/1.4.1.A" \
		"file:${UPDATE_NIGHTLY_HOME}/3.5.25.G"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/latest" "publish-nightly" "test07 latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/3.5.25.G"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x" "publish-nightly" "test07 1.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.5.A" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M" "file:${UPDATE_NIGHTLY_HOME}/1.2.8.P" "file:${UPDATE_NIGHTLY_HOME}/1.4.1.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x/latest" "publish-nightly" "test07 1.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x" "publish-nightly" "test07 1.0.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x/latest" "publish-nightly" "test07 1.0.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x" "publish-nightly" "test07 1.0.0.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x/latest" "publish-nightly" "test07 1.0.0.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.5.x" "publish-nightly" "test07 1.0.5.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.5.x/latest" "publish-nightly" "test07 1.0.5.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.x" "publish-nightly" "test07 1.4.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M" "file:${UPDATE_NIGHTLY_HOME}/1.4.1.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.x/latest" "publish-nightly" "test07 1.4.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.5.x" "publish-nightly" "test07 1.4.5.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M"	
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.5.x/latest" "publish-nightly" "test07 1.4.5.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.2.x" "publish-nightly" "test07 1.2.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.2.8.P"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.2.x/latest" "publish-nightly" "test07 1.2.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.2.8.P"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.2.8.x" "publish-nightly" "test07 1.2.8.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.2.8.P"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.2.8.x/latest" "publish-nightly" "test07 1.2.8.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.2.8.P"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.1.x" "publish-nightly" "test07 1.4.1.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.1.A"	
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.1.x/latest" "publish-nightly" "test07 1.4.1..x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.1.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.x" "publish-nightly" "test07 3.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/3.5.25.G"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.x/latest" "publish-nightly" "test07 3.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/3.5.25.G"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.5.x" "publish-nightly" "test07 3.5.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/3.5.25.G"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.5.x/latest" "publish-nightly" "test07 3.5.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/3.5.25.G"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.5.25.x" "publish-nightly" "test07 3.5.25.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/3.5.25.G"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.5.25.x/latest" "publish-nightly" "test07 3.5.25.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/3.5.25.G"
}

test08() {
	LSTEST "Test publish-nightly 1.4.5.Z"
	${SCRIPT_PATH}/../publish-nightly.sh "${dummySite}" "1.4.5.Z"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}" "publish-nightly" "test08 all" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.5.A" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M" "file:${UPDATE_NIGHTLY_HOME}/1.2.8.P" "file:${UPDATE_NIGHTLY_HOME}/1.4.1.A" \
		"file:${UPDATE_NIGHTLY_HOME}/3.5.25.G" "file:${UPDATE_NIGHTLY_HOME}/1.4.5.Z"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/latest" "publish-nightly" "test08 latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/3.5.25.G"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x" "publish-nightly" "test08 1.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.5.A" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M" "file:${UPDATE_NIGHTLY_HOME}/1.2.8.P" "file:${UPDATE_NIGHTLY_HOME}/1.4.1.A" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.Z"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x/latest" "publish-nightly" "test08 1.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.Z"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x" "publish-nightly" "test08 1.0.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x/latest" "publish-nightly" "test08 1.0.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x" "publish-nightly" "test08 1.0.0.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x/latest" "publish-nightly" "test08 1.0.0.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.5.x" "publish-nightly" "test08 1.0.5.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.5.x/latest" "publish-nightly" "test08 1.0.5.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.x" "publish-nightly" "test08 1.4.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M" "file:${UPDATE_NIGHTLY_HOME}/1.4.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.4.5.Z"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.x/latest" "publish-nightly" "test08 1.4.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.Z"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.5.x" "publish-nightly" "test08 1.4.5.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M" "file:${UPDATE_NIGHTLY_HOME}/1.4.5.Z"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.5.x/latest" "publish-nightly" "test08 1.4.5.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.Z"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.2.x" "publish-nightly" "test08 1.2.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.2.8.P"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.2.x/latest" "publish-nightly" "test08 1.2.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.2.8.P"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.2.8.x" "publish-nightly" "test08 1.2.8.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.2.8.P"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.2.8.x/latest" "publish-nightly" "test08 1.2.8.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.2.8.P"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.1.x" "publish-nightly" "test08 1.4.1.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.1.A"	
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.1.x/latest" "publish-nightly" "test08 1.4.1..x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.1.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.x" "publish-nightly" "test07 3.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/3.5.25.G"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.x/latest" "publish-nightly" "test08 3.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/3.5.25.G"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.5.x" "publish-nightly" "test08 3.5.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/3.5.25.G"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.5.x/latest" "publish-nightly" "test08 3.5.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/3.5.25.G"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.5.25.x" "publish-nightly" "test08 3.5.25.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/3.5.25.G"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.5.25.x/latest" "publish-nightly" "test08 3.5.25.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/3.5.25.G"
}

test09() {
	LSTEST "Test publish-nightly 1.4.6.A"
	${SCRIPT_PATH}/../publish-nightly.sh "${dummySite}" "1.4.6.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}" "publish-nightly" "test09 all" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.5.A" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M" "file:${UPDATE_NIGHTLY_HOME}/1.2.8.P" "file:${UPDATE_NIGHTLY_HOME}/1.4.1.A" \
		"file:${UPDATE_NIGHTLY_HOME}/3.5.25.G" "file:${UPDATE_NIGHTLY_HOME}/1.4.5.Z" "file:${UPDATE_NIGHTLY_HOME}/1.4.6.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/latest" "publish-nightly" "test09 latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/3.5.25.G"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x" "publish-nightly" "test09 1.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.5.A" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M" "file:${UPDATE_NIGHTLY_HOME}/1.2.8.P" "file:${UPDATE_NIGHTLY_HOME}/1.4.1.A" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.Z" "file:${UPDATE_NIGHTLY_HOME}/1.4.6.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x/latest" "publish-nightly" "test09 1.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.6.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x" "publish-nightly" "test09 1.0.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x/latest" "publish-nightly" "test09 1.0.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x" "publish-nightly" "test09 1.0.0.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x/latest" "publish-nightly" "test09 1.0.0.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.5.x" "publish-nightly" "test09 1.0.5.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.5.x/latest" "publish-nightly" "test09 1.0.5.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.0.5.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.x" "publish-nightly" "test09 1.4.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M" "file:${UPDATE_NIGHTLY_HOME}/1.4.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.4.5.Z" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.6.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.x/latest" "publish-nightly" "test09 1.4.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.6.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.5.x" "publish-nightly" "test09 1.4.5.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.M" "file:${UPDATE_NIGHTLY_HOME}/1.4.5.Z"	
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.5.x/latest" "publish-nightly" "test09 1.4.5.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.5.Z"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.2.x" "publish-nightly" "test09 1.2.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.2.8.P"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.2.x/latest" "publish-nightly" "test09 1.2.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.2.8.P"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.2.8.x" "publish-nightly" "test09 1.2.8.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.2.8.P"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.2.8.x/latest" "publish-nightly" "test09 1.2.8.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.2.8.P"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.1.x" "publish-nightly" "test09 1.4.1.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.1.A"	
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.1.x/latest" "publish-nightly" "test09 1.4.1..x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.1.A"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.x" "publish-nightly" "test07 3.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/3.5.25.G"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.x/latest" "publish-nightly" "test09 3.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/3.5.25.G"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.5.x" "publish-nightly" "test09 3.5.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/3.5.25.G"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.5.x/latest" "publish-nightly" "test09 3.5.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/3.5.25.G"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.5.25.x" "publish-nightly" "test09 3.5.25.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/3.5.25.G"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.5.25.x/latest" "publish-nightly" "test09 3.5.25.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/3.5.25.G"
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.6.x" "publish-nightly" "test09 1.4.6.x" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.6.A"	
	testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.4.6.x/latest" "publish-nightly" "test09 1.4.6.x/latest" "${reports}" \
		"file:${UPDATE_NIGHTLY_HOME}/1.4.6.A"
}

beforeTest "${reports}"

test01
test02
test03
test04
test05
test06
test07
test08
test09

afterTest "${reports}"