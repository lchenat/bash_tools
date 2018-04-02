#!/bin/bash

# Install anaconda, the anaconda version may have been updated
function _setup() {
	read -p "Input anaconda version you want to install:" version
	if [ -z "$version" ]; then
		version=5.1.0
	fi
	echo "anaconda version: $version"
	get_sys
	if [[ "$sys" =~ ^Linux ]]; then
		sys="Linux"
	else
		sys="MacOSX"
	fi
	echo "system version: $sys"
	file="Anaconda3-${version}-${sys}-x86_64.sh"
	echo "The file to be downloaded: ${file}"
	if [ ! -f ~/.tmp/${file} ]; then
		wget -P ~/.tmp/ "https://repo.continuum.io/archive/${file}"
	fi
	chmod +x ~/.tmp/${file}
	~/.tmp/${file}
	while true; do
		read -p "Anaconda is in ~/.tmp, do you want to delete it?(yes/no)" ans
		if [ "$ans" == "yes" ]; then
			rm -rf ~/.tmp/${file}
			break
		elif [ "$ans" == "no" ]; then
			echo "the setup file is left"
			break
		else
			echo "you can only input yes or no"
		fi
	done
}
