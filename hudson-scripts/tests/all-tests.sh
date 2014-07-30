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

_SCRIPT_PATH="$(dirname "${0}")"

"${_SCRIPT_PATH}/test-publish-nightly.sh"
"${_SCRIPT_PATH}/test-clean-nightly.sh"
"${_SCRIPT_PATH}/test-git-publish.sh"