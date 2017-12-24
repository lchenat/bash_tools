#!/bin/bash

# get the script directory name
# dirname: parse a path to get the directory name
G_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"

function g() {
	case $1 in
		push)
			if [[ -z "$2" ]]; then
				echo "Please write message"
			else
				git add .
				git commit -m "$2"
				git push origin master
			fi
			;;
		pull)
			git pull origin master
			;;
		fpush)
			git push origin master --force
			;;
		fpull)
			git fetch --all && git reset --hard origin/master
			;;
		*)
			echo "undefined command"
			;;
	esac
}
