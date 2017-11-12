#!/bin/bash

# get the script directory name
# dirname: parse a path to get the directory name
TO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"

# input: a path
# output: replace the first one by the list path, otherwise return empty string
# output stores in var: $dpath
function span_path() {
	IFS="/" read -r name path <<< "$1"
	if [[ "$1" == */ ]]; then
		path="$path/"
	fi
	if [[ "$path" == / ]]; then
		path=""
	fi
	dpath=""
	if [[ -f "${TO_DIR}/list/${name}" ]]; then
		n=$( cat "${TO_DIR}/list/${name}" )	
		dpath="${n%/}/${path}"	
	fi
}

function expand_path() { # name, path, r, all files or only dir
	L=( $( compgen -W '$list' $1 ) )
	if [ ! -z "$L" ]; then	
		p="$( cat "${TO_DIR}/list/$1" )/$2"
		if [[ "$p" == */ ]]; then
			p="${p}."
		fi
		dir=$( dirname "$p" )
		base=$( basename "$p" )	
		if [ $base = "." ]; then
			base=""	
		fi
		if [[ $4 -ne 0 ]]; then 
			COMPREPLY=( $( compgen -W "$( cd $dir && ls -p -1 2>/dev/null )" -- $base ) )		
		else
			COMPREPLY=( $( compgen -W "$( cd $dir && ls -1 -d -- */ 2>/dev/null )" -- $base ) )			
		fi
		COMPREPLY=( "${COMPREPLY[@]/#/${3%/*}/}" )
	fi
}

function ls_path() { # path, finally did not use this, expand a normal path and add ~ in front
	if [[ "$1" == */ ]]; then
		p="${1}."
	fi
	dir=$( dirname "$p" )
	base=$( basename "$p" )	
	if [[ $base = "." ]]; then
		base=""	
	fi
	COMPREPLY=( $( compgen -W "$( cd $dir && ls -1 2>/dev/null )" -- $base ) )	
	if [[ "$1" =~ / ]]; then
		COMPREPLY=( "${COMPREPLY[@]/#/${p%/*}/}" )
	fi
	COMPREPLY=( "${COMPREPLY[@]/#/~}" )
}

function _complete_to() {
	local cur
	COMPREPLY=()
	cur=${COMP_WORDS[COMP_CWORD]}
	pre=${COMP_WORDS[${COMP_CWORD}-1]}
	list=$( ls "$TO_DIR/list" )
	IFS="/" read -r name path <<< "$cur"
	if [[ "$cur" == */ ]]; then
		path="$path/"
	fi
	if [[ "$cur" == -* ]]; then
		COMPREPLY=( $( compgen -W "-c -d -l" -- $cur ) )
		return 0
	fi
	if [[ "$pre" == -* ]]; then
		case $pre in	
			-d)
				COMPREPLY=( $( compgen -W "$list" $cur ) )
				;;
			*)
				;;
		esac
	else
		if [[ "$cur" =~ / ]]; then
			expand_path $name $path	$cur 0
		else
			COMPREPLY=( $( compgen -W "$list" $name ) )
			if [[ ${#COMPREPLY[@]} -eq 1 ]]; then
				COMPREPLY[0]="${COMPREPLY[0]}/"
			fi
		fi
	fi
	return 0
}

function _complete_tt() {
	local cur
	COMPREPLY=()
	cur=${COMP_WORDS[COMP_CWORD]}
	list=$( ls "${TO_DIR}/list" )
	if [[ "$cur" == +* ]]; then
		p=${cur#+}
		IFS="/" read -r name path <<< "$p"
		if [[ "$p" == */ ]]; then
			path="$path/"
		fi
		if [[ "$p" =~ / ]]; then
			expand_path $name $path	$p 1
		else
			COMPREPLY=( $( compgen -W "$list" "$name" ) )
			if [[ ${#COMPREPLY[@]} -eq 1 ]]; then
				COMPREPLY[0]="${COMPREPLY[0]}/"
			fi
		fi
		COMPREPLY=( "${COMPREPLY[@]/#/+}" )
	fi
	return 0
}

complete -F _complete_to -o nospace -o filenames to 
# complete -F _complete_tt -o nospace -o filenames -o default -b -c tt 
complete -F _complete_tt -o nospace -o filenames -o default tt 

source "$TO_DIR/to.sh"
