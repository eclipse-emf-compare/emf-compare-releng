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

export WORKING_DIRECTORY="${WORKING_DIRECTORY:-$(pwd)/target}"
LS_OUTPUT="${WORKING_DIRECTORY}/log.txt"

if [ ! -d "${WORKING_DIRECTORY}" ]; then
	LSDEBUG "Creating '${WORKING_DIRECTORY}'"
	mkdir -p "${WORKING_DIRECTORY}"
fi

[ -z "${_WORKDIR_MODULE_INITED:-}" ] && {
	export _WORKDIR_MODULE_INITED="resolved"

	rm -f "${LS_OUTPUT}"
	touch "${LS_OUTPUT}"
	tail -f "${LS_OUTPUT}" &
	_TAIL_PID=$!
	trap "kill ${_TAIL_PID}" EXIT
} || true