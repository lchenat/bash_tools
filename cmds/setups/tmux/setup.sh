#!/bin/bash


function _setup() {
	echo "### all tmux.conf files you current have ###"
	echo $( ls "${CMDS_DIR}/setups/tmux/files" )
	while true; do
		read -p "Please input the name of the tmux.conf you want to install:" file
		if [ -f "${CMDS_DIR}/setups/tmux/files/${file}" ]; then
			if [ -f ~/.tmux.conf ]; then
				alt ".tmux.conf exists, do you want to save it to .tmux_bp.conf?"
				if ${alt_res}; then
					cp ~/.tmux.conf ~/.tmux_bp.conf
				fi
			fi
			cp "${CMDS_DIR}/setups/tmux/files/${file}" ~/.tmux.conf
			break
		else
			echo "The file ${file} does not exist"
		fi
	done
}
