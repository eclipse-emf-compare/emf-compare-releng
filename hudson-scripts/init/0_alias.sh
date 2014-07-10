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

# To avoid error find: paths must precede expression
# It takes apart the argument list to find and concatenates the arguments back into another 
# argument list but inserts -regextype posix-awk in front of any -iregex or -regex arguments it finds.
# see http://superuser.com/a/666634
findGnuRegex () {
    args=
    for arg in $*
    do
        case ${arg} in
            -ireges|-regex)
                args="${args} -regextype posix-extended ${arg}"
                ;;
            *)
                args="${args} ${arg}"
                ;;
        esac
    done
    set -f
    command find ${args}
    set +f
}

# define alias depending on the underlying OS 
# e.g., regex on BSD-like and GNU-like OS are not handled through the same options for
# find and sed.
if [[ "${OSTYPE}" == "linux"* || "${OSTYPE}" == "cygwin"* ]]; then
	alias sed-regex="sed -r"
	alias find-regex="findGnuRegex"

	LSDEBUG 'sed-regex="sed -r"'
	LSDEBUG 'find-regex="findGnuRegex"'
elif [[ "${OSTYPE}" == "darwin"* || "${OSTYPE}" == "freebsd"* ]]; then
	alias sed-regex="sed -E"
	alias find-regex="find -E"

	LSDEBUG 'sed-regex="sed -E"'
	LSDEBUG 'find-regex="find -E"'
else
	LSCRITICAL "Unknown 'OSTYPE'=${OSTYPE}."
	exit -1
fi
