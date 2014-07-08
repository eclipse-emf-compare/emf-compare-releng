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

DIRNAME=$(dirname "$0")

# load bootstrap scripts (starting with _) in order
for S in $(ls -1 "$DIRNAME/init/_"* | sort -t '.' -k1n);
do
	echo "Loading bootstrap '$S'"
	source $S
done

# load scripts (not starting with _) in order
for S in $( (ls -1 "$DIRNAME/init/"*;ls -1 "$DIRNAME/init/_"*) | sort -t '.' -k1n | uniq -u );
do
	LSINFO "Loading '$S'"
	source $S
done
