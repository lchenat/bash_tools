#!/bin/bash

# get the script directory name
# dirname: parse a path to get the directory name
TO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"

function _complete_list() {
	local cur
	COMPREPLY=()
	cur=${COMP_WORDS[COMP_CWORD]}
	list=$( ls "$TO_DIR/list" )
	IFS='/' read -r name path <<< "$cur"
	if [ -z $path ]; then
		COMPREPLY=( $( compgen -W '$list' $name ) )
	else
		L=( $( compgen -W '$list' $name ) )
		echo "$L"
	fi
	# COMPREPLY=( $( compgen -W '$list' $cur ) )
	return 0
}

# sudo mkdir -p "${SCIRPT_DIR}/list"
complete -F _complete_list to 
source "$TO_DIR/to.sh"
