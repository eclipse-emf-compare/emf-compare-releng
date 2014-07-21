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

set -o nounset 
set -o errexit
set -o errtrace
set -o functrace

shopt -s nullglob 
shopt -s extglob
shopt -s expand_aliases

SCRIPT_PATH="$(dirname "${0}")"
INIT_PATH="${INIT_PATH:-${SCRIPT_PATH}/init}"

# load bootstrap scripts (starting with _) in order
for S in $( echo "${INIT_PATH}/_"* | tr ' ' '\n' | sort -t '.' -k1n );
do
	if [ ! -z "${DEBUG_BOOTSTRAP:-}" ]; then
		echo "[DEBUG]    Loading bootstrap '${S}'"
	fi
	source ${S}
done

# load scripts (not starting with _) in order
for S in $( ( echo "${INIT_PATH}/"* ; echo "${INIT_PATH}/_"*) | tr ' ' '\n' | sort -t '.' -k1n | uniq -u );
do
	LSDEBUG "Loading '${S}'"
	source ${S}
	LSDEBUG "'${S}' has been loaded"
done

