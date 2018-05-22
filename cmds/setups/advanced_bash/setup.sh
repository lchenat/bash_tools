#!/bin/bash

# Install anaconda, the anaconda version may have been updated
function _setup() {
	# autocd, fast cd
	sys="$( uname -s )"
	case "$sys" in
		Linux*) 
			echo "system: Linux, install autocd"
			echo "shopt -s autocd" >> ~/.bashrc
			echo "alias ...=\"cd ../..\"" >> ~/.bashrc
			echo "alias ....=\"cd ../../..\"" >> ~/.bashrc
			;;
		Darwin*)
			echo "system: Mac"
			echo "alias ..=\"cd ..\"" >> ~/.bash_profile
			echo "alias ...=\"cd ../..\"" >> ~/.bash_profile
			echo "alias ....=\"cd ../../..\"" >> ~/.bash_profile
			;;
		*)
	esac
	# inputrc
	echo "\"\e\e[A\":history-search-backward" >> ~/.inputrc
	echo "\"\e\e[B\":history-search-forward" >> ~/.inputrc
}
