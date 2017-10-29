#!/bin/bash

# -P to resolve softlink
function get_path() {
	# dpath="$( cd "$( dirname $1 )" && pwd -P )/$( basename $1 )"
	dpath="$( cd $1 && pwd -P )"
}


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"
FILES="$( cd $SCRIPT_DIR && ls -d -- */ )"

for f in $FILES; do
	source "${SCRIPT_DIR}/${f}init.sh"
done
