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

_REMOTE="origin"
_DEFAULT_BRANCH="master"

# udpates or clone the repository pointed by $repositoryURL into working
# directory $wd. The branch to checkout is $branch or $_DEFAULT_BRANCH if
# not specified
git_updateLocalRepository() {
	local gitURL="${1}"
	local wd="${2}"
	local branch="${3:-${_DEFAULT_BRANCH}}"

	local oldPwd="$(pwd)"

	if [ ! -d "${wd}/.git" ]; then
		# removing all the content as cloning in an existing directory is only
		# allowed in an empty directory.
		LSDEBUG "Removing content of '${wd}'"
		rm -fr "${wd}"
		LSDEBUG "Cloning '${gitURL}'"
		git clone --quiet --no-checkout --origin "${_REMOTE}" "${gitURL}" "${wd}"
	else		
		LSDEBUG "Change directory to '${wd}'"
		cd "${wd}" 

		LSDEBUG "Fetching changes of '${gitURL}' on '${branch}'"
		git fetch --quiet "${_REMOTE}" "+${branch}:${branch}"
	
		# if there are some changes in the working directory or in the index (i.e. staged 
		# changes), then we reset to HEAD
		if ! git diff --quiet --exit-code || ! git diff --quiet --exit-code --cached; then
			LSDEBUG "Resetting local changes to HEAD"
			git reset --quiet --hard HEAD
		fi

		# remove untracked entries from the repo
		local untrackedEntries=( $( git ls-files --other --exclude-standard --directory | tr '\n' ' ' ) )
		if [ ${#untrackedEntries[@]} -gt 0 ]; then
			for untrackedEntry in ${untrackedEntries[@]}; do 
				LSDEBUG "Removing untracked entry '${untrackedEntry}'"
				rm -rf "${untrackedEntry}"
			done
		fi
	fi

	if [ "$(pwd)" != "${wd}" ]; then
		# this happens when cloning for the first time
		LSDEBUG "Change directory to '${wd}'"
		cd "${wd}" 
	fi

	# the head to checkout is the ref pointed by $_REMOTE/$branch
	head="$( git show-ref "${_REMOTE}/${branch}" | cut -d ' ' -f1 )"
	LSDEBUG "Checkouting '${head}'"
	git checkout --quiet "${head}"

	LSDEBUG "Going back to '${oldPwd}'"
	cd "${oldPwd}"
}

# Adds, commits and push all the changes to the current repository. It will
# set $message as the commit message. It will update remote branch 
# "refs/remotes/$_REMOTE/$branch"
git_updateRemoteRepository() {
	local message="${1}"
	local author="${2}"
	local branch="${3:-${_DEFAULT_BRANCH}}"
	git add --all
	git commit --quiet --author="${author}" --message="${message}"
	git push --quiet "${_REMOTE}" "HEAD:${branch}"
}
