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
	chmod +x setups/$1/setup.sh
	setups/$1/setup.sh
}

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
