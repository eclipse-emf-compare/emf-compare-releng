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

if [ -d 'p2-admin' ]; then
	LSINFO "Removing previous p2-admin folder"
	rm -rf "p2-admin"
fi

if [ ! -f "${P2_ADMIN_ARCHIVE}" ]; then
	LSDEBUG "Unable to find p2-admin archive '${P2_ADMIN_ARCHIVE}'"
	LSINFO "Downloading p2-admin '${P2_ADMIN_URL}'"
	wget -q --no-check-certificate ${P2_ADMIN_URL} -O - > "${P2_ADMIN_ARCHIVE}"
fi

LSINFO "Unziping '${P2_ADMIN_ARCHIVE}'"
tar zxf "${P2_ADMIN_ARCHIVE}"

LSINFO "Defining p2 aliases"
shopt -s expand_aliases

LSDEBUG "composite-repository='p2-admin/p2-admin -vm ${JAVA_HOME}/bin/java -application org.eclipselabs.equinox.p2.composite.repository'"
alias composite-repository="p2-admin/p2-admin -vm ${JAVA_HOME}/bin/java -application org.eclipselabs.equinox.p2.composite.repository"

# Create a p2 index file for composite repositories
createP2Index() {
	LSDEBUG "Creating p2.index file in ${1}"
	cat > "${1}/p2.index" <<EOF
version = 1
metadata.repository.factory.order = compositeContent.xml,\!
artifact.repository.factory.order = compositeArtifacts.xml,\!
EOF
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
