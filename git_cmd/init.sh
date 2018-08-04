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
		c) # check whether exp is runnable
			s=$(git submodule update --init --recursive) # update submodule
			s=$(git status --porcelain)
			if ! [ -z "$s" ]; then 
				echo "####### status procelain: files are modified #######"
				echo "$s"
			fi
			#s=$( git status )
			#if ! [[ $s = *"Your branch is up-to-date"* ]] || [[ $s = *"Changes not staged for commit"* ]] ; then
				#echo "--- message on git status ---"
				#git status
			#fi
			s=$( g cc )
			if ! [ "$s" = "Up-to-date" ]; then
				echo "####### branch check: branch not up to date #######"
				echo "$s"
			fi
			;;
		cc)
			UPSTREAM='@{u}'
			LOCAL=$(git rev-parse @)
			REMOTE=$(git rev-parse "$UPSTREAM")
			if ! [ -z "$REMOTE" ]; then 
				BASE=$(git merge-base @ "$UPSTREAM")
				if [ $LOCAL = $REMOTE ]; then
					echo "Up-to-date"
				elif [ $LOCAL = $BASE ]; then
					echo "Need to pull"
				elif [ $REMOTE = $BASE ]; then
					echo "Need to push"
				else
					echo "Diverged"
				fi
			else
				echo "No upstream branch"
			fi
			;;
		*)
			echo "undefined command"
			;;
	esac
}
