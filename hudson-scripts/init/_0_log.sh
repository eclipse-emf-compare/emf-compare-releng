#!/bin/bash
# Logging library for Bash
# Copyright (c) 2012 Yu-Jie Lin
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Modified from https://github.com/livibetter/log.sh/releases/tag/v0.3

LS_OUTPUT=${LS_OUTPUT:-/dev/stdout}
# XXX need more flexible templating, currently manual padding for level names
#LS_DEFAULT_FMT=${LS_DEFAULT_FMT:-'[${_LS_LEVEL_STR}][${FUNCNAME[1]}:${BASH_LINENO[0]}]'}
LS_DEFAULT_FMT=${LS_DEFAULT_FMT:-'%-10s %s [%s:%s]\n'}

LS_DEBUG_LEVEL=10
LS_INFO_LEVEL=20
LS_WARNING_LEVEL=30
LS_ERROR_LEVEL=40
LS_CRITICAL_LEVEL=50
LS_LEVEL=${LS_LEVEL:-${LS_DEBUG_LEVEL}}
# LS_LEVELS structure:
# Level, Level Name, Level Format, Before Log Entry, After Log Entry
LS_LEVELS=(
  ${LS_DEBUG_LEVEL}    '[DEBUG]'    '\e[0;32m'    '\e[0m'
  ${LS_INFO_LEVEL}     '[INFO]'     '\e[0;34m'    '\e[0m'
  ${LS_WARNING_LEVEL}  '[WARNING]'  '\e[0;33m'    '\e[0m'
  ${LS_ERROR_LEVEL}    '[ERROR]'    '\e[0;31m'    '\e[0m'
  ${LS_CRITICAL_LEVEL} '[CRITICAL]' '\e[0;37;41m' '\e[0m'
)

_LS_FIND_LEVEL_STR () {
local LEVEL=${1}
local i
_LS_LEVEL_STR="${LEVEL}"
for ((i=0; i<${#LS_LEVELS[@]}; i+=4)); do
  if [[ "${LEVEL}" == "${LS_LEVELS[i]}" ]]; then
    _LS_LEVEL_STR="${LS_LEVELS[i+1]}"
    #_LS_LEVEL_BEGIN="${LS_LEVELS[i+2]}"
    #_LS_LEVEL_END="${LS_LEVELS[i+3]}"
    return 0
  fi
done
_LS_LEVEL_BEGIN=""
_LS_LEVEL_END=""
return 1
}

# General logging function
# ${1}: Level
LSLOG () {
  local LEVEL=${1}
  shift
  (( LEVEL < LS_LEVEL )) && return 0
  _LS_FIND_LEVEL_STR ${LEVEL}
  # if no message was passed, read it from STDIN
  local _MSG
  [[ $# -ne 0 ]] && _MSG="$@" || _MSG="$(cat)"
  printf "${LS_DEFAULT_FMT}" "${_LS_LEVEL_STR}" "${_MSG}" "$(basename ${BASH_SOURCE[1]})" "${BASH_LINENO[0]}" >> "${LS_OUTPUT}"
}

# Log Call Stack
LSCALLSTACK () {
  local i=0
  local FRAMES=${#BASH_LINENO[@]}
  if [ "${FRAMES}" -gt "4" ]; then
    local start=3
  else 
    local start=0
  fi
  # starts at 3 to skips LSCALLSTACK and __onErr, the last one in arrays
  for ((i=$start; i<FRAMES-1; i++)); do
    echo '  File' \"${BASH_SOURCE[i+1]}\", line ${BASH_LINENO[i]}, in ${FUNCNAME[i+1]} >> "${LS_OUTPUT}"
    # Grab the source code of the line
    sed -n -r ${BASH_LINENO[i]}'s/^[:space:]*/    /p' "${BASH_SOURCE[i+1]}" >> "${LS_OUTPUT}"
    # TODO extract arugments from "${BASH_ARGC[@]}" and "${BASH_ARGV[@]}"
    # It requires `shopt -s extdebug'
  done
}

alias LSDEBUG='LSLOG 10'
alias LSINFO='LSLOG 20'
alias LSWARNING='LSLOG 30'
alias LSERROR='LSLOG 40'
alias LSCRITICAL='LSLOG 50'
alias LSLOGSTACK='LSDEBUG Stack trace ; LSCALLSTACK'
