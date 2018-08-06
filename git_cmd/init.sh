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
		cm) # commit modified and deleted
			git commit -a -m "$2"
			;;
		mb) # move branch to the current head
			branch=${2-"master"}
			git branch -D "$branch"
			git branch "$branch"
			git checkout "$branch"
			;;
		c) # check whether exp is runnable
			s=$( g bc )
			if ! [ "$s" = "not a git file" ]; then
				if ! [ "$s" = "Up-to-date" ]; then
					echo "####### branch check: branch not up to date #######"
					echo "$s"
				fi
				s=$(git submodule update --init --recursive) # update submodule
				s=$(git status --porcelain)
				if ! [ -z "$s" ]; then 
					echo "####### status procelain: files are modified #######"
					echo "$s"
				fi
			else
				echo "$s"
			fi
			;;
		bc) # branch check
			UPSTREAM='@{u}'
			LOCAL=$(git rev-parse @)
			if [ -z "$LOCAL" ]; then
				echo "not a git file"
			else
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
			fi
			;;
		*)
			echo "undefined command"
			;;
	esac
}
