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

P2_ADMIN_VERSION="1.1.0"

if [[ "${OSTYPE}" == "linux"* || "${OSTYPE}" == "freebsd"* ]]; then
	OSWS="linux.gtk"
	FILE_EXT="tar.gz"
elif [[ "${OSTYPE}" == "cygwin"* ]]; then
	OSWS="win32.win32"
	FILE_EXT="zip"
elif [[ "${OSTYPE}" == "darwin"* ]]; then
	OSWS="macosx.cocoa"
	FILE_EXT="tar.gz"
else
	LSCRITICAL "Unknown 'OSTYPE'=${OSTYPE}."
	exit -1
fi

if [[ $(uname -m) == *"64"* ]]; then
	ARCH="x86_64"
else
	ARCH="x86"
fi

PLATFORM_SPECIFIER="${OSWS}.${ARCH}"
LSDEBUG "Platform specifier is '${PLATFORM_SPECIFIER}'"
P2_ADMIN_ARCHIVE="p2-admin-${P2_ADMIN_VERSION}-${PLATFORM_SPECIFIER}.${FILE_EXT}"
P2_ADMIN_URL="https://github.com/mbarbero/p2-admin/releases/download/v${P2_ADMIN_VERSION}/${P2_ADMIN_ARCHIVE}"

# prevents re-downloading the p2-admin archive each time.
if [ ! -f "${WORKING_DIRECTORY}/${P2_ADMIN_ARCHIVE}" ]; then
	LSDEBUG "Unable to find p2-admin archive '${WORKING_DIRECTORY}/${P2_ADMIN_ARCHIVE}'"
	LSINFO "Downloading p2-admin '${P2_ADMIN_URL}'"
	wget -q --no-check-certificate ${P2_ADMIN_URL} -O - > "${WORKING_DIRECTORY}/${P2_ADMIN_ARCHIVE}"
fi

# this way, we are sure to have a clean p2-admin install, without any p2-cache.
# the p2-admin archive will be unzipped afterwards.
if [ -d '${WORKING_DIRECTORY}/p2-admin' ]; then
	LSDEBUG "Removing previous 'p2-admin' folder"
	rm -rf "${WORKING_DIRECTORY}/p2-admin"
fi

LSDEBUG "Unziping '${P2_ADMIN_ARCHIVE}'"
tar zxf "${WORKING_DIRECTORY}/${P2_ADMIN_ARCHIVE}" -C "${WORKING_DIRECTORY}"

LSDEBUG "Defining p2 aliases"
LSDEBUG "composite-repository='${WORKING_DIRECTORY}/p2-admin/p2-admin -vm ${JAVA_HOME}/bin/java -application org.eclipselabs.equinox.p2.composite.repository'"
alias composite-repository="${WORKING_DIRECTORY}/p2-admin/p2-admin -vm ${JAVA_HOME}/bin/java -application org.eclipselabs.equinox.p2.composite.repository"

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
	
	LSDEBUG "Creating redirection from '${name}'@'${from}' to '${to}'"
	mkdir -p "${from}"
	rm -f "${from}/compositeArtifacts."*
	rm -f "${from}/compositeContent."*
	composite-repository -location "${from}" -add "${to}" -repositoryName "${name}" -compressed
	createP2Index ${from}
}
