#!/bin/bash


function _setup() {
	fn="id_rsa"
	echo "### all $fn files you current have ###"
	echo $( ls "${CMDS_DIR}/setups/$fn/files" )
	while true; do
		read -p "Please input the name of the $fn you want to install:" file
		if [ -d "${CMDS_DIR}/setups/$fn/files/${file}" ]; then
			if [ -f ~/.ssh/id_rsa ]; then
				alt "$fn exists, do you want to save it to ${fn}_bp?"
				if ${alt_res}; then
					cp ~/.ssh/id_rsa ~/.ssh/id_rsa_bp
					cp ~/.ssh/id_rsa.pub ~/.ssh/id_rsa_bp.pub
				fi
			fi
			cp "${CMDS_DIR}/setups/id_rsa/files/${file}/id_rsa" ~/.ssh/
			cp "${CMDS_DIR}/setups/id_rsa/files/${file}/id_rsa.pub" ~/.ssh/
			break
		else
			echo "The file ${file} does not exist"
		fi
	done
}
