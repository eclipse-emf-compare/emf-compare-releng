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

__onExit() {
	local RETURN=$?

	LSDEBUG "Program will exit, saving the environment variables to a file for later debugging"
	echo $(env|sort) > env.txt

	if [ $RETURN -ne 0 -a $RETURN -lt 129 -o $RETURN -gt 165 ]; then
		LSCRITICAL "An error occurred"
		LSLOGSTACK
	fi

	exit $RETURN
}

__onInterruption() {
	local RETURN=$?
	LSDEBUG "Program has been interrupted"
	exit $RETURN
}

trap __onInterruption INT TERM
trap __onExit EXIT