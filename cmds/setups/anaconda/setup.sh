#!/bin/bash

# import functions
source ../init.sh

# Install anaconda, the anaconda version may have been updated
read -p "anaconda version:" version
if [ -z "$version" ]; then
	version=5.1.0
fi
echo "anaconda version: $version"
get_sys
if [ "$sys" == Linux* ]; then
	sys="Linux"
else
	sys="MacOSX"
fi
echo "system version: $sys"
file="Anaconda3-${version}-${sys}-x86_64.sh"
echo "The file to be downloaded: ${file}"

mkdir .tmp
wget -P /.tmp/ "https://repo.continuum.io/archive/${file}"
chmod +x "/.tmp/${file}"
.tmp/${file}
while True; do
	read -p "Anaconda is in .tmp, do you want to delete it?(yes/no)" ans
	if [ "$ans" == "yes" ]; then
		rm -rf .tmp
		break
	elif [ "$ans" == "no" ]; then
		echo "the file .tmp is left"
		break
	else
		echo "you can only input yes or no"
	fi
done
