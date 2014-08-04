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

P2_ADMIN_VERSION="${P2_ADMIN_VERSION:-1.1.0}"

_initP2Admin() {
	local wd="${1}"

	local osws=""
	local archiveFileExtension=""
	if [[ "${OSTYPE}" == "linux"* || "${OSTYPE}" == "freebsd"* ]]; then
		osws="linux.gtk"
		archiveFileExtension="tar.gz"
	elif [[ "${OSTYPE}" == "cygwin"* ]]; then
		osws="win32.win32"
		archiveFileExtension="zip"
	elif [[ "${OSTYPE}" == "darwin"* ]]; then
		osws="macosx.cocoa"
		archiveFileExtension="tar.gz"
	else
		LSCRITICAL "Unknown 'OSTYPE'=${OSTYPE}."
		exit -1
	fi

	local arch=""
	if [[ $(uname -m) == *"64"* ]]; then
		arch="x86_64"
	else
		arch="x86"
	fi

	local platformSpecifier="${osws}.${arch}"
	LSDEBUG "Platform specifier is '${platformSpecifier}'"
	local p2AdminArchive="p2-admin-${P2_ADMIN_VERSION}-${platformSpecifier}.${archiveFileExtension}"
	local p2AdminURL="https://github.com/mbarbero/p2-admin/releases/download/v${P2_ADMIN_VERSION}/${p2AdminArchive}"

	# prevents re-downloading the p2-admin archive each time.
	if [ ! -f "${wd}/${p2AdminArchive}" ]; then
		LSDEBUG "Unable to find p2-admin archive '${wd}/${p2AdminArchive}'"
		LSINFO "Downloading p2-admin '${p2AdminURL}'"
		wget -q --no-check-certificate ${p2AdminURL} -O - > "${wd}/${p2AdminArchive}"
	fi

	# this way, we are sure to have a clean p2-admin install, without any p2-cache.
	# the p2-admin archive will be unzipped afterwards.
	if [ -d '${wd}/p2-admin' ]; then
		LSDEBUG "Removing previous 'p2-admin' folder"
		rm -rf "${wd}/p2-admin"
	fi

	LSDEBUG "Unziping '${p2AdminArchive}'"
	tar zxf "${wd}/${p2AdminArchive}" -C "${wd}"
}

compositeRepository() {
	if [ ! -f "${WORKING_DIRECTORY}/p2-admin/p2-admin" ]; then
		_initP2Admin "${WORKING_DIRECTORY}"
	fi

	"${WORKING_DIRECTORY}/p2-admin/p2-admin" \
		-vm "${JAVA_HOME}/bin/java" \
		-application "org.eclipselabs.equinox.p2.composite.repository" \
		$@
}

# Create a p2 index file for composite repositories
createP2Index() {
	if [ ! -f "${1}/p2.index" ]; then
		LSDEBUG "Creating p2.index file in ${1}"
		cat > "${1}/p2.index" <<EOF
version = 1
metadata.repository.factory.order = compositeContent.xml,\!
artifact.repository.factory.order = compositeArtifacts.xml,\!
EOF
	fi
}

# Remove any previous file from the ${1} path and create a composite repository with a single
# child (${2}). The composite will be name ${3}.
createRedirect() {
	local from="${1}"
	local to="${2}"
	local name="${3}"

	if [ ! -f "${WORKING_DIRECTORY}/p2-admin/p2-admin" ]; then
		_initP2Admin "${WORKING_DIRECTORY}"
	fi
	
	LSDEBUG "Creating redirection from '${name}'@'${from}' to '${to}'"
	mkdir -p "${from}"
	rm -f "${from}/compositeArtifacts."*
	rm -f "${from}/compositeContent."*
	compositeRepository -location "${from}" -add "${to}" -repositoryName "${name}" -compressed
	createP2Index ${from}
}
