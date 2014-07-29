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
export ECLIPSE_DOCUMENT_ROOT="${WORKING_DIRECTORY}/tests"

export SCRIPT_PATH="$(dirname "${0}")"
export INIT_PATH="${SCRIPT_PATH}/../init"

source "${SCRIPT_PATH}/../init.sh"
source "${SCRIPT_PATH}/test-utils.sh"

dummyGitRepo="${SCRIPT_PATH}/data/dummy-git-repo.tar.gz"

remotes="${ECLIPSE_DOCUMENT_ROOT}/remotes"
locals="${ECLIPSE_DOCUMENT_ROOT}/locals"
reports="${ECLIPSE_DOCUMENT_ROOT}/results-git-publish.txt"

test01() {
	LSTEST "Testing git_updateLocalRepository 01"
	mkdir -p "${remotes}"
	tar zxf "$dummyGitRepo" -C "${remotes}"
	mv "${remotes}/dummy-git-repo.git" "${remotes}/dummy-git-repo1.git"
	git_updateLocalRepository "${remotes}/dummy-git-repo1.git" "${locals}/dummy-git-repo1" "master"	
	assertStringEquals "AAAA" $(cat ${locals}/dummy-git-repo1/file1) "git-publish" "test01 file1 contents" "${reports}"
	assertStringEquals "BBBB" $(cat ${locals}/dummy-git-repo1/file2) "git-publish" "test01 file2 contents" "${reports}"
	git_updateLocalRepository "${remotes}/dummy-git-repo1.git" "${locals}/dummy-git-repo1" "master"	
	assertStringEquals "AAAA" $(cat ${locals}/dummy-git-repo1/file1) "git-publish" "test01 redo file1 contents" "${reports}"
	assertStringEquals "BBBB" $(cat ${locals}/dummy-git-repo1/file2) "git-publish" "test01 redo file2 contents" "${reports}"
}

test02() {
	LSTEST "Testing git_updateLocalRepository 02"
	mkdir -p "${remotes}"
	tar zxf "$dummyGitRepo" -C "${remotes}"
	mv "${remotes}/dummy-git-repo.git" "${remotes}/dummy-git-repo2.git"
	git_updateLocalRepository "${remotes}/dummy-git-repo2.git" "${locals}/dummy-git-repo2" "master"	
	
	LSTEST "Modifying file1 in remote to CCCC, and push"
	local oldPwd="$(pwd)"
	mkdir -p "${remotes}/dummy-git-repo2-clone"
	cd "${remotes}/dummy-git-repo2-clone"
	git clone --quiet "${remotes}/dummy-git-repo2.git" "."
	echo "CCCC" > file1
	git add file1
	git commit --quiet -m "change file1 to CCCC"
	git push --quiet origin master
	cd "${oldPwd}"

	git_updateLocalRepository "${remotes}/dummy-git-repo2.git" "${locals}/dummy-git-repo2" "master"	
	assertStringEquals "CCCC" $(cat ${locals}/dummy-git-repo2/file1) "git-publish" "test02 file1 contents" "${reports}"
	assertStringEquals "BBBB" $(cat ${locals}/dummy-git-repo2/file2) "git-publish" "test02 file2 contents" "${reports}"
}

test03() {
	LSTEST "Testing git_updateLocalRepository 03 (modifiy local repo to test reset)"
	mkdir -p "${remotes}"
	tar zxf "$dummyGitRepo" -C "${remotes}"
	mv "${remotes}/dummy-git-repo.git" "${remotes}/dummy-git-repo3.git"
	git_updateLocalRepository "${remotes}/dummy-git-repo3.git" "${locals}/dummy-git-repo3" "master"	
	
	local oldPwd="$(pwd)"
	cd "${locals}/dummy-git-repo3"
	LSTEST "Changing the content of a file"
	echo "CCCC" > "${locals}/dummy-git-repo3/file1"
	LSTEST "Creating a new file"
	echo "DDDD" > "${locals}/dummy-git-repo3/newFile"
	LSTEST "Creating a new file in a subfolder"
	mkdir "${locals}/dummy-git-repo3/newFolder"
	echo "FOOBAR" > "${locals}/dummy-git-repo3/newFolder/foobar"
	LSTEST "Staging a changed file"
	echo "ZZZZ" > "${locals}/dummy-git-repo3/file2"
	git add "${locals}/dummy-git-repo3/file2"
	cd "${oldPwd}"
	
	git_updateLocalRepository "${remotes}/dummy-git-repo3.git" "${locals}/dummy-git-repo3" "master"	
	assertStringEquals "AAAA" $(cat ${locals}/dummy-git-repo3/file1) "git-publish" "test03 file1 contents" "${reports}"
	assertStringEquals "BBBB" $(cat ${locals}/dummy-git-repo3/file2) "git-publish" "test03 file2 contents" "${reports}"

	local oldPwd="$(pwd)"
	cd "${locals}/dummy-git-repo3"
	git diff --quiet --exit-code
	assertIntEquals 0 $? "git-publish" "test03 local change" "${reports}"
	git diff --quiet --exit-code --cached
	assertIntEquals 0 $? "git-publish" "test03 local staged change" "${reports}"
	local untrackedEntries=( $( git ls-files --other --exclude-standard --directory | tr '\n' ' ' ) )
	assertIntEquals 0 ${#untrackedEntries[@]} "git-publish" "test03 local untracked entries" "${reports}"
	cd "${oldPwd}"
}

test04() {
	LSTEST "Testing git_updateRemoteRepository 04"
	mkdir -p "${remotes}"
	tar zxf "$dummyGitRepo" -C "${remotes}"
	mv "${remotes}/dummy-git-repo.git" "${remotes}/dummy-git-repo4.git"
	git_updateLocalRepository "${remotes}/dummy-git-repo4.git" "${locals}/dummy-git-repo4" "master"	
	
	local oldPwd="$(pwd)"
	cd "${locals}/dummy-git-repo4"
	LSTEST "Changing the content of a file"
	echo "CCCC" > "${locals}/dummy-git-repo4/file1"
	LSTEST "Creating a new file"
	echo "DDDD" > "${locals}/dummy-git-repo4/newFile"
	LSTEST "Creating a new file in a subfolder"
	mkdir "${locals}/dummy-git-repo4/newFolder"
	echo "FOOBAR" > "${locals}/dummy-git-repo4/newFolder/foobar"
	git_updateRemoteRepository "update" "Test <me@test.org>" "master"
	cd "${oldPwd}"

	local oldPwd="$(pwd)"
	mkdir -p "${remotes}/dummy-git-repo4-clone"
	cd "${remotes}/dummy-git-repo4-clone"
	git clone --quiet "${remotes}/dummy-git-repo4.git" "."
	assertStringEquals "CCCC" $(cat ${remotes}/dummy-git-repo4-clone/file1) "git-publish" "test04 file1 contents" "${reports}"
	assertStringEquals "BBBB" $(cat ${remotes}/dummy-git-repo4-clone/file2) "git-publish" "test04 file2 contents" "${reports}"
	assertStringEquals "DDDD" $(cat ${remotes}/dummy-git-repo4-clone/newFile) "git-publish" "test04 newFile contents" "${reports}"
	assertStringEquals "FOOBAR" $(cat ${remotes}/dummy-git-repo4-clone/newFolder/foobar) "git-publish" "test04 newFolder/foobar contents" "${reports}"
	cd "${oldPwd}"
}

beforeTest "${reports}"

test01
test02
test03
test04

afterTest "${reports}"