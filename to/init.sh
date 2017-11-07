#!/bin/bash

# get the script directory name
# dirname: parse a path to get the directory name
TO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"

function _complete_list() {
	local cur
	COMPREPLY=()
	cur=${COMP_WORDS[COMP_CWORD]}
	list=$( ls "$TO_DIR/list" )
	IFS="/" read -r name path <<< "$cur"
	if [[ "$cur" == */ ]]; then
		path="$path/"
	fi
	if [[ "$cur" =~ / ]]; then
		L=( $( compgen -W '$list' $name ) )
		if [ ! -z "$L" ]; then	
			p="$( cat "${TO_DIR}/list/$name" )/$path"
			if [[ "$p" == */ ]]; then
				p="${p}."
			fi
			dir=$( dirname "$p" )
			base=$( basename "$p" )	
			if [ $base = "." ]; then
				base=""	
			fi
			COMPREPLY=( $( compgen -W "$( cd $dir && ls -1 -d -- */ 2>/dev/null )" -- $base ) )	
			COMPREPLY=( "${COMPREPLY[@]/#/${cur%/*}/}" )
		fi
	else
		COMPREPLY=( $( compgen -W "$list" $name ) )
	fi
	# COMPREPLY=( $( compgen -W '$list' $cur ) )
	return 0
}

complete -F _complete_list -o nospace -o filenames to 
source "$TO_DIR/to.sh"
