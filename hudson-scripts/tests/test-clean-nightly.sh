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
export DOWNLOAD_PATH="cleaner"
export ECLIPSE_DOCUMENT_ROOT="${WORKING_DIRECTORY}/tests/documentRoot"
export DOWNLOAD_URL="file:${ECLIPSE_DOCUMENT_ROOT}/${DOWNLOAD_PATH}"

export SCRIPT_PATH="$(dirname "${0}")"
export INIT_PATH="${SCRIPT_PATH}/../init"

source "${SCRIPT_PATH}/../init.sh"
source "${SCRIPT_PATH}/test-utils.sh"

reports="${WORKING_DIRECTORY}/tests/results-clean-nightly.txt"
sitesToClean="$(pwd)/${SCRIPT_PATH}/data/sites-to-clean.tar.gz"

# #zippedUpdateSiteURL="file:$(pwd)/${SCRIPT_PATH}/data/dummy-site.zip"
# for M in "1" "2" "3"; do 
#     for m in "0" "1" "2"; do 
#         for u in "0" "1" "2"; do 
#             for q in "A" "B" "C"; do 
#                 printf '"file:${UPDATE_NIGHTLY_HOME}/'"$M.$m.$u.$q"'" '
# #               ${SCRIPT_PATH}/../publish-nightly.sh "${zippedUpdateSiteURL}" "$M.$m.$u.$q"
#             done 
#             printf '\\\n'
#         done 
#     done 
# done
# exit 0

beforeClass_this() {
    # cleaning test folder
    if [ -d "${ECLIPSE_DOCUMENT_ROOT}" ]; then
        LSTEST "Removing test folder '${ECLIPSE_DOCUMENT_ROOT}'"
        rm -rf "${ECLIPSE_DOCUMENT_ROOT}"
    fi
    mkdir -p "${ECLIPSE_DOCUMENT_ROOT}"

    if [ ! -d "${UPDATE_NIGHTLY_HOME}" ]; then
        mkdir -p "${UPDATE_NIGHTLY_HOME}"
    fi
}

test01() {
    LSTEST "Test clean-nightly 01"
    rm -rf "${UPDATE_NIGHTLY_HOME}/"*
    tar zxf "${sitesToClean}" -C "${UPDATE_NIGHTLY_HOME}"
    ${SCRIPT_PATH}/../clean-nightly.sh "1.0.0" 3
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}" "clean-nightly" "test01 all" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/latest" "clean-nightly" "test01 latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x" "clean-nightly" "test01 1.0.0.x" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x/latest" "clean-nightly" "test01 1.0.0.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x" "clean-nightly" "test01 1.0.x" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x/latest" "clean-nightly" "test01 1.0.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x" "clean-nightly" "test01 1.x" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x/latest" "clean-nightly" "test01 1.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C"
}

test02() {
    LSTEST "Test clean-nightly 02"
    rm -rf "${UPDATE_NIGHTLY_HOME}/"*
    tar zxf "${sitesToClean}" -C "${UPDATE_NIGHTLY_HOME}"
    ${SCRIPT_PATH}/../clean-nightly.sh "1.0.0" 2
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}" "clean-nightly" "test02 all" "${reports}" \
                                              "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/latest" "clean-nightly" "test02 latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x" "clean-nightly" "test02 1.0.0.x" "${reports}" \
                                              "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x/latest" "clean-nightly" "test02 1.0.0.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x" "clean-nightly" "test02 1.0.x" "${reports}" \
                                              "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x/latest" "clean-nightly" "test02 1.0.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x" "clean-nightly" "test02 1.x" "${reports}" \
                                              "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x/latest" "clean-nightly" "test02 1.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C"
}

test03() {
    LSTEST "Test clean-nightly 03"
    rm -rf "${UPDATE_NIGHTLY_HOME}/"*
    tar zxf "${sitesToClean}" -C "${UPDATE_NIGHTLY_HOME}"
    ${SCRIPT_PATH}/../clean-nightly.sh "1.0.0" 1
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}" "clean-nightly" "test03 all" "${reports}" \
                                                                                    "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/latest" "clean-nightly" "test03 latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x" "clean-nightly" "test03 1.0.0.x" "${reports}" \
                                                                                    "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x/latest" "clean-nightly" "test03 1.0.0.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x" "clean-nightly" "test03 1.0.x" "${reports}" \
                                                                                    "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x/latest" "clean-nightly" "test03 1.0.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x" "clean-nightly" "test03 1.x" "${reports}" \
                                                                                    "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x/latest" "clean-nightly" "test03 1.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C"
}

test04() {
    LSTEST "Test clean-nightly 04"
    rm -rf "${UPDATE_NIGHTLY_HOME}/"*
    tar zxf "${sitesToClean}" -C "${UPDATE_NIGHTLY_HOME}"
    ${SCRIPT_PATH}/../clean-nightly.sh "1.0.0" 0
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}" "clean-nightly" "test04 all" "${reports}" \
                                                                                                                          \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/latest" "clean-nightly" "test04 latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    # replace with test for folder existing
    assertFolderDoesNotExist "${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x" "clean-nightly" "test04 1.0.0.x" "${reports}"
    assertFolderDoesNotExist "${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x/latest" "clean-nightly" "test04 1.0.0.x/latest" "${reports}"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x" "clean-nightly" "test04 1.0.x" "${reports}" \
                                                                                                                          \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x/latest" "clean-nightly" "test04 1.0.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x" "clean-nightly" "test04 1.x" "${reports}" \
                                                                                                                          \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x/latest" "clean-nightly" "test04 1.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C"
}

test05() {
    LSTEST "Test clean-nightly 05"
    rm -rf "${UPDATE_NIGHTLY_HOME}/"*
    tar zxf "${sitesToClean}" -C "${UPDATE_NIGHTLY_HOME}"
    ${SCRIPT_PATH}/../clean-nightly.sh "1.0.2" 1
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}" "clean-nightly" "test05 all" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.C" \
                                                                                    "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/latest" "clean-nightly" "test05 latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.2.x" "clean-nightly" "test05 1.0.2.x" "${reports}" \
                                                                                    "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.2.x/latest" "clean-nightly" "test05 1.0.2.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x" "clean-nightly" "test05 1.0.x" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.C" \
                                                                                    "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x/latest" "clean-nightly" "test05 1.0.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x" "clean-nightly" "test05 1.x" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.C" \
                                                                                    "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x/latest" "clean-nightly" "test05 1.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C"
}

test06() {
    LSTEST "Test clean-nightly 06"
    rm -rf "${UPDATE_NIGHTLY_HOME}/"*
    tar zxf "${sitesToClean}" -C "${UPDATE_NIGHTLY_HOME}"
    ${SCRIPT_PATH}/../clean-nightly.sh "1.0.2" 0
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}" "clean-nightly" "test06 all" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.C" \
                                                                                                                          \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/latest" "clean-nightly" "test06 latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    assertFolderDoesNotExist "${UPDATE_NIGHTLY_HOME}/streams/1.0.2.x" "clean-nightly" "test06 1.0.2.x" "${reports}"
    assertFolderDoesNotExist "${UPDATE_NIGHTLY_HOME}/streams/1.0.2.x/latest" "clean-nightly" "test06 1.0.2.x/latest" "${reports}"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x" "clean-nightly" "test06 1.0.x" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.C" 

    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x/latest" "clean-nightly" "test06 1.0.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.1.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x" "clean-nightly" "test06 1.x" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.C" \
                                                                                                                          \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x/latest" "clean-nightly" "test06 1.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C"
}

test07() {
    LSTEST "Test clean-nightly 07"
    rm -rf "${UPDATE_NIGHTLY_HOME}/"*
    tar zxf "${sitesToClean}" -C "${UPDATE_NIGHTLY_HOME}"
    ${SCRIPT_PATH}/../clean-nightly.sh "1.2.2" 2
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}" "clean-nightly" "test07 all" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.C" \
                                              "file:${UPDATE_NIGHTLY_HOME}/1.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/latest" "clean-nightly" "test07 latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.2.2.x" "clean-nightly" "test07 1.2.2.x" "${reports}" \
                                              "file:${UPDATE_NIGHTLY_HOME}/1.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.2.2.x/latest" "clean-nightly" "test07 1.2.2.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.2.x" "clean-nightly" "test07 1.2.x" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.C" \
                                              "file:${UPDATE_NIGHTLY_HOME}/1.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.2.x/latest" "clean-nightly" "test07 1.2.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x" "clean-nightly" "test07 1.x" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.C" \
                                              "file:${UPDATE_NIGHTLY_HOME}/1.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x/latest" "clean-nightly" "test07 1.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C"
}

test08() {
    LSTEST "Test clean-nightly 08"
    rm -rf "${UPDATE_NIGHTLY_HOME}/"*
    tar zxf "${sitesToClean}" -C "${UPDATE_NIGHTLY_HOME}"
    ${SCRIPT_PATH}/../clean-nightly.sh "1.2.2" 0
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}" "clean-nightly" "test08 all" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.C" \
                                                                                                                          \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/latest" "clean-nightly" "test08 latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    assertFolderDoesNotExist "${UPDATE_NIGHTLY_HOME}/streams/1.2.2.x" "clean-nightly" "test08 1.2.2.x" "${reports}"
    assertFolderDoesNotExist "${UPDATE_NIGHTLY_HOME}/streams/1.2.2.x/latest" "clean-nightly" "test08 1.2.2.x/latest" "${reports}"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.2.x" "clean-nightly" "test08 1.2.x" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.2.x/latest" "clean-nightly" "test08 1.2.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.1.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x" "clean-nightly" "test08 1.x" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x/latest" "clean-nightly" "test08 1.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.1.C"
}

test09() {
    LSTEST "Test clean-nightly 09"
    rm -rf "${UPDATE_NIGHTLY_HOME}/"*
    tar zxf "${sitesToClean}" -C "${UPDATE_NIGHTLY_HOME}"
    ${SCRIPT_PATH}/../clean-nightly.sh "3.2.1" 2
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}" "clean-nightly" "test09 all" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.C" \
                                              "file:${UPDATE_NIGHTLY_HOME}/3.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/latest" "clean-nightly" "test09 latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.2.1.x" "clean-nightly" "test09 3.2.1.x" "${reports}" \
                                              "file:${UPDATE_NIGHTLY_HOME}/3.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.C" 
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.2.1.x/latest" "clean-nightly" "test09 3.2.1.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.1.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.2.x" "clean-nightly" "test09 3.2.x" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.C" \
                                              "file:${UPDATE_NIGHTLY_HOME}/3.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.2.x/latest" "clean-nightly" "test09 3.2.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.x" "clean-nightly" "test09 3.x" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.C" \
                                              "file:${UPDATE_NIGHTLY_HOME}/3.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.x/latest" "clean-nightly" "test09 3.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
}

test10() {
    LSTEST "Test clean-nightly 10"
    rm -rf "${UPDATE_NIGHTLY_HOME}/"*
    tar zxf "${sitesToClean}" -C "${UPDATE_NIGHTLY_HOME}"
    ${SCRIPT_PATH}/../clean-nightly.sh "3.2.1" 0
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}" "clean-nightly" "test10 all" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.C" \
                                                                                                                          \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/latest" "clean-nightly" "test10 latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    assertFolderDoesNotExist "${UPDATE_NIGHTLY_HOME}/streams/3.2.1.x" "clean-nightly" "test09 3.2.1.x" "${reports}"
    assertFolderDoesNotExist "${UPDATE_NIGHTLY_HOME}/streams/3.2.1.x/latest" "clean-nightly" "test09 3.2.1.x/latest" "${reports}"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.2.x" "clean-nightly" "test10 3.2.x" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.C" \
                                                                                                                          \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.2.x/latest" "clean-nightly" "test10 3.2.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.x" "clean-nightly" "test10 3.x" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.C" \
                                                                                                                          \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.x/latest" "clean-nightly" "test10 3.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
}

test11() {
    LSTEST "Test clean-nightly 11"
    rm -rf "${UPDATE_NIGHTLY_HOME}/"*
    tar zxf "${sitesToClean}" -C "${UPDATE_NIGHTLY_HOME}"
    ${SCRIPT_PATH}/../clean-nightly.sh "3.2.2" 2
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}" "clean-nightly" "test11 all" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.C" \
                                              "file:${UPDATE_NIGHTLY_HOME}/3.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/latest" "clean-nightly" "test11 latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.2.2.x" "clean-nightly" "test11 3.2.2.x" "${reports}" \
                                              "file:${UPDATE_NIGHTLY_HOME}/3.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.2.2.x/latest" "clean-nightly" "test11 3.2.2.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.2.x" "clean-nightly" "test11 3.2.x" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.C" \
                                              "file:${UPDATE_NIGHTLY_HOME}/3.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.2.x/latest" "clean-nightly" "test11 3.2.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.x" "clean-nightly" "test11 3.x" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.C" \
                                              "file:${UPDATE_NIGHTLY_HOME}/3.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.x/latest" "clean-nightly" "test11 3.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.2.C"
}

test12() {
    LSTEST "Test clean-nightly 12"
    rm -rf "${UPDATE_NIGHTLY_HOME}/"*
    tar zxf "${sitesToClean}" -C "${UPDATE_NIGHTLY_HOME}"
    ${SCRIPT_PATH}/../clean-nightly.sh "3.2.2" 0
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}" "clean-nightly" "test12 all" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/1.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/1.2.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/2.2.2.A" "file:${UPDATE_NIGHTLY_HOME}/2.2.2.B" "file:${UPDATE_NIGHTLY_HOME}/2.2.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/latest" "clean-nightly" "test12 latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.1.C"
    assertFolderDoesNotExist "${UPDATE_NIGHTLY_HOME}/streams/3.2.2.x" "clean-nightly" "test12 3.2.2.x" "${reports}"
    assertFolderDoesNotExist "${UPDATE_NIGHTLY_HOME}/streams/3.2.2.x/latest" "clean-nightly" "test12 3.2.2.x/latest" "${reports}"    
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.2.x" "clean-nightly" "test12 3.2.x" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.2.x/latest" "clean-nightly" "test12 3.2.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.1.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.x" "clean-nightly" "test12 3.x" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.0.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.0.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.1.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.1.2.A" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.B" "file:${UPDATE_NIGHTLY_HOME}/3.1.2.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.0.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.0.C" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.1.A" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.B" "file:${UPDATE_NIGHTLY_HOME}/3.2.1.C"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/3.x/latest" "clean-nightly" "test12 3.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/3.2.1.C"
}

test13() {
    LSTEST "Test clean-nightly 13"
    local dummySite="file:$(pwd)/${SCRIPT_PATH}/data/dummy-site.zip"
    rm -rf "${UPDATE_NIGHTLY_HOME}/"*
    ${SCRIPT_PATH}/../publish-nightly.sh "${dummySite}" "1.0.0.A"
    ${SCRIPT_PATH}/../publish-nightly.sh "${dummySite}" "1.0.0.B"
    ${SCRIPT_PATH}/../clean-nightly.sh "1.0.0" 1
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}" "clean-nightly" "test13 all" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/latest" "clean-nightly" "test13 latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x" "clean-nightly" "test13 1.0.0.x" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.0.x/latest" "clean-nightly" "test13 1.0.0.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x" "clean-nightly" "test13 1.0.x" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.0.x/latest" "clean-nightly" "test13 1.0.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x" "clean-nightly" "test13 1.x" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
    testCompositeRepositoryContent "file:${UPDATE_NIGHTLY_HOME}/streams/1.x/latest" "clean-nightly" "test13 1.x/latest" "${reports}" \
        "file:${UPDATE_NIGHTLY_HOME}/1.0.0.B"
}

test14() {
    LSTEST "Test clean-nightly 14"
    local dummySite="file:$(pwd)/${SCRIPT_PATH}/data/dummy-site.zip"
    rm -rf "${UPDATE_NIGHTLY_HOME}/"*
    ${SCRIPT_PATH}/../publish-nightly.sh "${dummySite}" "1.0.0.A"
    ${SCRIPT_PATH}/../publish-nightly.sh "${dummySite}" "1.0.0.B"
    ${SCRIPT_PATH}/../clean-nightly.sh "1.0.0" 0
    assertEmptyFolder "${UPDATE_NIGHTLY_HOME}" "clean-nightly" "test14 all" "${reports}"
}

beforeClass_this
beforeClass "${reports}"

test01
test02
test03
test04
test05
test06
test07
test08
test09
test10
test11
test12
test13
test14

afterClass "${reports}"