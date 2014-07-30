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

LSTEST() {
	echo "[TEST]     $@"
}

LSFAILURE() {
	echo "[FAILURE]  $@"
}

LSPASS() {
	echo "[PASS]     $@"
}

assertIntEquals() {
	local expected="${1}"
	local actual="${2}"
	local classname="${3}"
	local name="${4}"
	local file="${5}"
	shift 5
	if [ ${expected} -ne ${actual} ]; then
		LSFAILURE "${classname} ${name} 
	$@
	expected=${expected}
	actual=${actual}"
		echo "failure;${classname};${name};$@" >> "${file}"
	else 
		LSPASS "${classname} ${name}"
		echo "success;${classname};${name}" >> "${file}"
	fi
}

assertStringEquals() {
	local expected="${1}"
	local actual="${2}"
	local classname="${3}"
	local name="${4}"
	local file="${5}"
	shift 5
	if [ "${expected}" != "${actual}" ]; then
		LSFAILURE "${classname} ${name} 
	$@
	expected=${expected}
	actual=${actual}"
		echo "failure;${classname};${name};$@" >> "${file}"
	else 
		LSPASS "${classname} ${name}"
		echo "success;${classname};${name}" >> "${file}"
	fi
}

testCompositeRepositoryContent() {
	local url="${1}"
	local classname="${2}"
	local name="${3}"
	local file="${4}"
	shift 4
	local expectedContents=("$@")
	actualContents=( $(composite-repository -location "${url}" -list) )
	assertIntEquals ${#expectedContents[@]} ${#actualContents[@]} \
		"${classname}" "${name} (size)" "${file}" "Contents size of composite repository '${url}' does not match"
	for i in ${!actualContents[*]}; do
		assertStringEquals "${expectedContents[$i]}" "${actualContents[$i]}" \
			"${classname}" "${name} contents(${i})" "${file}" "Contents of composite repository '${url}' does not match"
	done	
}

assertFolderDoesNotExist() {
	local folder="${1}"
	local classname="${2}"
	local name="${3}"
	local file="${4}"
	shift 4
	if [ -d "${folder}" ]; then
		LSFAILURE "${classname} ${name} 
	Folder '${folder}' should not exists"
		echo "failure;${classname};${name};Folder '${folder}' should not exists" >> "${file}"
	else 
		LSPASS "${classname} ${name}"
		echo "success;${classname};${name}" >> "${file}"
	fi
}

assertEmptyFolder() {
	local folder="${1}"
	local classname="${2}"
	local name="${3}"
	local file="${4}"
	shift 4
	local folderContents=( $(echo "${folder}/"*) )
	if [ "${#folderContents[@]}" -ne "0" ]; then
		LSFAILURE "${classname} ${name} 
	Folder '${folder}' should be empty"
		echo "failure;${classname};${name};Folder '${folder}' should be empty" >> "${file}"
	else 
		LSPASS "${classname} ${name}"
		echo "success;${classname};${name}" >> "${file}"
	fi
}

toJunitXML() {
	local file="${1}"
	local nbTests=$(cat "${file}" | grep -v '^[ \t]*#[ \t]*' | wc -l | sed 's/ //g')
	echo "<testsuite tests=\"${nbTests}\">"
	IFS=$'\r\n' GLOBIGNORE='*' :; local tests=($(cat ${file} | grep -v '^[ \t]*#[ \t]*'))
	for test in ${tests[@]}; do 
		local result=($(echo $test | cut -f 1 -d ';'))
		local classname=($(echo $test | cut -f 2 -d ';'))
		local name=($(echo $test | cut -f 3 -d ';'))
		if [ "${result}" = "success" ]; then
			echo "\t<testcase classname=\"${classname}\" name=\"$name\"/>"
		else
			local error=($(echo $test | cut -f 4 -d ';'))
			echo "\t<testcase classname=\"${classname}\" name=\"$name\">"
			echo "\t\t<failure type=\"failure\">${error}</failure>"
			echo "\t</testcase>"
		fi
	done
	echo "</testsuite>"
}

beforeClass() {
	local reports="${1}"
	
	timestamp="$(date)"
	echo "# ${timestamp}" > "${reports}"

	xmlReports=$(echo "${reports}" | sed 's/\.txt/\.xml/')
	echo "<!-- ${timestamp} -->" > "${xmlReports}"
}

afterClass() {
	local reports="${1}"
	xmlReports=$(echo "${reports}" | sed 's/\.txt/\.xml/')
	toJunitXML "${reports}" >> "${xmlReports}"
}