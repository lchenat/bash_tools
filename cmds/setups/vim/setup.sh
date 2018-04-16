#!/bin/bash


function _setup() {
	if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
		echo "Vundle does not exist, install Vundle"
		git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	fi
	echo "### all vimrc files you current have ###"
	echo $( ls "${CMDS_DIR}/setups/vim/files" )
	while true; do
		read -p "Please input the name of the vimrc you want to install:" file
		if [ -f "${CMDS_DIR}/setups/vim/files/${file}" ]; then
			if [ -f ~/.vimrc ]; then
				alt ".vimrc exists, do you want to save it to .vimrc_bp?"
				if ${alt_res}; then
					cp ~/.vimrc ~/.vimrc_bp
				fi
			fi
			cp "${CMDS_DIR}/setups/vim/files/${file}" ~/.vimrc
			break
		else
			echo "The file ${file} does not exist"
		fi
	done
}
