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

clean() {
	local wd="${1}"

	rm -rf "${wd}"
}

# retrieved from http://stackoverflow.com/a/12498485
relativize() {
    # both $1 and $2 are absolute paths beginning with /
    # returns relative path to $2/$targetPath from $1/$sourcePath
    local sourcePath=$1
    local targetPath=$2

    local common_part=$sourcePath # for now
    local result="" # for now
 
    while [[ "${targetPath#$common_part}" == "${targetPath}" ]]; do
        # no match, means that candidate common part is not correct
        # go up one level (reduce common part)

        common_part="$(dirname $common_part)"
        # and record that we went back, with correct / handling
        if [[ -z $result ]]; then
            result=".."
        else
            result="../$result"
        fi
    done

    if [[ $common_part == "/" ]]; then
        # special case for root (no common path)
        result="$result/"
    fi

    # since we now have identified the common part,
    # compute the non-common part
    local forward_part="${targetPath#$common_part}"

    # and now stick all parts together
    if [[ -n $result ]] && [[ -n $forward_part ]]; then
        result="$result$forward_part"
    elif [[ -n $forward_part ]]; then
        # extra slash removal
        result="${forward_part:1}"
    fi

    echo $result
}
