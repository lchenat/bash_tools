#!/bin/bash

# -P to resolve softlink
function get_path() {
	dpath="$( cd "$( dirname $1 )" && pwd -P )/$( basename $1 )"
	if [[ "$dpath" == *\. ]]; then
		dpath="$dpath/"	
	fi
	# dpath="$( cd $1 && pwd -P )"
}

function get_dir_path() {
	dpath="$( cd $1 && pwd -P )"
}

function join_by { 
	local IFS="$1" 
	shift 
	join_str="$*"
}

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"
FILES="$( cd $SCRIPT_DIR && ls -d -- */ )"

for f in $FILES; do
	source "${SCRIPT_DIR}/${f}init.sh"
done
