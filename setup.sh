#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"

sys="$( uname -s )"  

case "$sys" in
	Linux*) 
		echo "system: Linux"
		echo "source ${SCRIPT_DIR}/init.sh" >> ~/.bashrc
		;;
	Darwin*)
		echo "system: Mac"
		echo "source ${SCRIPT_DIR}/init.sh" >> ~/.bash_profile
		;;
	*)
esac

