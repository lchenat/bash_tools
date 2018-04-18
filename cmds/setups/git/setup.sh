#!/bin/bash


function _setup() {
	echo "### all gitconfig files you current have ###"
	echo $( ls "${CMDS_DIR}/setups/git/files" )
	while true; do
		read -p "Please input the name of the gitconfig you want to install:" file
		if [ -f "${CMDS_DIR}/setups/git/files/${file}" ]; then
			if [ -f ~/.gitconfig ]; then
				alt ".gitconfig exists, do you want to save it to .gitconfig_bp?"
				if ${alt_res}; then
					cp ~/.gitconfig ~/.gitconfig_bp
				fi
			fi
			cp "${CMDS_DIR}/setups/git/files/${file}" ~/.gitconfig
			break
		else
			echo "The file ${file} does not exist"
		fi
	done
}
