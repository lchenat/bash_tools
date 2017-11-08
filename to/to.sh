#!/bin/bash

function to() {
	case $1 in
		.)
			get_path $1
			bn="$( basename $dpath )"
			echo "$dpath" > "${TO_DIR}/list/$bn"
			echo "create a new link with name: $bn"
			echo "actual path: $dpath"
			;;
		-c)
			if [ "$3" = "" ]; then
				get_path $2
				bn="$( basename $dpath )"
				echo "$dpath" > "${TO_DIR}/list/$bn"
				echo "create a new link with name: $bn"
				echo "actual path: $dpath"
			else
				get_path $3
				# ln -s "$dpath" "${TO_DIR}/list/$2"
				echo "$dpath" > "${TO_DIR}/list/$2"
				echo "create a new link with name: $2"
				echo "actual path: $dpath"
			fi
			;;
		-d)
			rm -rf "${TO_DIR}/list/$2"
			;;
		-l)
			ls "${TO_DIR}/list"
			;;
		*)
			IFS="/" read -r name path <<< "$1" # "$1", the quote is very important
			if [ -f "${TO_DIR}/list/$name" ]; then
				read -r p < "${TO_DIR}/list/$name" 
				cd "$p/$path"
			else
				echo "$name does not exist"
			fi
			;;
	esac
			
}
