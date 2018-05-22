#!/bin/bash

CMDS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"

function send_ssh_key() {
	cat ~/.ssh/id_rsa.pub | ssh $1 "cat >> .ssh/authorized_keys"
}

# use this on other linux machine
function send_git_ssh_key() {
	scp ~/.ssh/id_rsa* $1:.ssh/
}

function setup() {
	#chmod +x "${CMDS_DIR}/setups/$1/setup.sh"
	#${CMDS_DIR}/setups/$1/setup.sh
	if [ $1 == "-s" ]; then
		source $2
		_setup
	elif [ $1 == "-g" ]; then
		git clone "git@github.com:lchenat/${2}.git"
	else
		source "${CMDS_DIR}/setups/$1/setup.sh"
		_setup
	fi
}

function _complete_setup() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "$(ls ${CMDS_DIR}/setups)" -- $cur) )
}

complete -F _complete_setup setup

# return to $sys
# Linux* or Darwin* (Mac)
function get_sys() {
	sys="$( uname -s )"  
}

# this works with setups/vim
function save_vimrc() {
	if [ -z "$1" ]; then
		echo "Please enter a name for your saved vimrc"
	else
		cp ~/.vimrc "${CMDS_DIR}/setups/vim/files/$1"
	fi
}

# this works with setups/vim
function save_gitconfig() {
	if [ -z "$1" ]; then
		echo "Please enter a name for your saved gitconfig"
	else
		cp ~/.gitconfig "${CMDS_DIR}/setups/git/files/$1"
	fi
}

# alternate choices (yes/no)
function alt() {
	if [ -z "$2" ]; then
		first="yes"
	else
		first="$2"
	fi
	if [ -z "$3" ]; then
		second="no"
	else
		second="$3"
	fi
	if [ -z "$1" ]; then
		msg="Please input one of the two choices(${first}/${second}):"
	else
		msg="${1}(${first}/${second}):"
	fi
	while true; do
		read -p "$msg" ans
		if [ "$ans" == "$first" ]; then
			alt_res=true
			break
		elif [ "$ans" == "$second" ]; then
			alt_res=false
			break
		else
			echo "You can only input ${first} or ${second}"
		fi
	done
}

# path will store the install path
function py-git-install() {
	if [ -z $1 ] || [ -z $2 ] || [ -z $3 ]; then
		echo "1:package_name 2:github_path 3:default_path"
		return 1
	fi
	python -c "import $1" &>/dev/null
	if (($? > 0)); then
		read -p "input path to install $1 (default: $3): " path	
		if [ -z $path ]; then
			path=$3
		fi
		if [ ! -d ${path}/$1 ]; then
			git clone $2 ${path}/$1
			cd ${path}/$1
			python setup.py develop
			cd -
		else
			echo "$1 already installed"
		fi
	fi
}
