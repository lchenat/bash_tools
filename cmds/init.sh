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
function save_tmux() {
	if [ -z "$1" ]; then
		echo "Please enter a name for your saved tmux.conf"
	else
		cp ~/.tmux.conf "${CMDS_DIR}/setups/tmux/files/$1"
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

function save_id_rsa() {
	if [ -z "$1" ]; then
		echo "Please enter a name for your saved id_rsa"
	else
		mkdir -p "${CMDS_DIR}/setups/id_rsa/files/$1"
		cp ~/.ssh/id_rsa "${CMDS_DIR}/setups/id_rsa/files/$1/"
		cp ~/.ssh/id_rsa.pub "${CMDS_DIR}/setups/id_rsa/files/$1/"
	fi
}

# alternate choices (yes/no)
# msg, first choice, second choice
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

# search through direcotry $1 and match the word $2
# can specify other option on the rest of arguments (-w: match the whole word)
function search() {
	args=( "$@" )
	grep --color=always -rn $1 -e $2 "${args[@]:2}"
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

function delete_first_line() {
	uid=$BASHPID
	tail -n +2 "$1" > ".delete_first_line.${uid}.tmp" && mv ".delete_first_line.${uid}.tmp" "$1"
}

function set_gpu() {
	export CUDA_VISIBLE_DEVICES=$1
}

function gpu() {
	echo "gpu: $CUDA_VISIBLE_DEVICES"
}

# Note: if you change the code during the job, it might effect the waiting job
function exp() {
	# color for echo
	RED=$(tput bold)
	BOLD=$(tput setaf 1)
	RS=$(tput sgr0)

	# specify the file path
	log_dir="${2-"${1}.exp.log"}"
	success="${3-"exp.success"}"
	error="${4-"exp.error"}"
	prog="${5-"exp.prog"}"
	lock="${6-".exp.lock"}"
	if ! [ -f "$1" ] || ! [ -s "$1" ]; then
		echo -e "${RED}${BOLD}exp:${RS} exp file does not exist or it is empty"
		return 1
	fi
	[[ -d $log_dir ]] || mkdir $log_dir
	new_exp=true
	if ! [ -f "$log_dir/$prog" ]; then # new experiment
		cp "$1" "$log_dir/$prog"
	elif ! [ -s "$log_dir/$prog" ]; then # old finished experiment, resume?
		alt "old finished experiment exists, do you want to replace it" "y" "n"
		if $alt_res; then
			cp "$1" "$log_dir/$prog"
			> "$log_dir/$success"
			> "$log_dir/$error"
		else
			return 1
		fi
	else
		new_exp=false
	fi
	check=$(g c)
	echo "$check"
	if [ "$check" = "not a git file" ]; then
		echo -e "${RED}${BOLD}exp warning:${RS} not a git file, cannot verify version"
	elif ! [ -z "$check" ]; then
		echo -e "${RED}${BOLD}exp:${RS} git is not completely up to date"
		echo "$check"
		alt "do you want to run the exp anyway?" "y" "n"
		if ! $alt_res; then
			return 1
		fi
	fi
	if ! [ "$check" = "not a git file" ]; then
		if ! [ -f "$log_dir/$success" ]; then
			new_exp=true
		fi
		if $new_exp; then
			echo "commit version: $(git log --oneline -1)" > "$log_dir/$success"
			echo "commit version: $(git log --oneline -1)" > "$log_dir/$error"
		else # try to join an experiment, need to verify git version
			cur="commit version: $(git log --oneline -1)"
			read -r fl < "$log_dir/$success"
			if [ "$cur" != "$fl" ]; then
				echo "${RED}${BOLD}exp:${RS} current git version modified, cannot join the origin job"
				return 1
			fi
		fi
	fi
	id=$BASHPID
	[[ -d ~/.exp ]] || mkdir ~/.exp
	# clear accidently left EXIT signal
	rm -rf ~/.exp/$id.EXIT
	# experiments retrieval loop
	while true; do
		(
			flock 9 || exit 1
			read -r cmd < "$log_dir/$prog"
			echo "$cmd" > ~/.exp/$id
			delete_first_line "$log_dir/$prog"
		)9>"$log_dir/$lock"
		read -r cmd < ~/.exp/$id
		if [ -s ~/.exp/$id ] && ! [[ "$cmd" == \#* ]]; then
			echo -e "${RED}${BOLD}command:${RS} $cmd"
			bash $CMDS_DIR/exp_run ~/.exp/$id $log_dir/$lock $log_dir/$prog $id
			# clean up after execution
			> ~/.exp/$id
			if [ -f ~/.exp/$id.EXIT ]; then
				rm -rf ~/.exp/$id.EXIT
				break
			fi
			if [ $? -eq 0 ]; then
				echo -e "${RED}${BOLD}exp:${RS} run successfully"
				flock "$log_dir/$lock" echo "$cmd" >> "$log_dir/$success"
			else
				echo -e "${RED}${BOLD}exp:${RS} execution failed, put into error"
				flock "$log_dir/$lock" echo "$cmd" >> "$log_dir/$error"
			fi
		fi
		if ! [ -s "$log_dir/$prog" ]; then
			break
		fi
	done
}

# https://www.pmg.com/blog/how-to-set-up-directory-specific-bash-or-other-shell-environments/
# https://github.com/chrisguitarguy/dotfiles/blob/master/bash/functions.sh
function make_env() {
    local env="$PWD/.env"
    if [ -f "$env" ]; then
        if [ -z "$CURRENT_ENV" ]; then
            # no current environment, source .env file
            builtin source "$env"
            export CURRENT_ENV="$env"
        elif [ ! "$CURRENT_ENV" = "$env" ]; then
            # we have a current environment setup
            # the environ we have setup is not this one
            # check to see if we have a deactivate function to run
            if [ "$(type -t deactivate)" = "function" ]; then
                deactivate
            fi
            builtin source "$env"
            export CURRENT_ENV="$env"
        fi
    fi
}

function env_cd() {
    if builtin cd "$@"; then
        make_env
	fi
}

# get python dependency in requirements.txt format for all .py in one directory
# make sure you are in the correct environment
# github install will be commented
function py_reqs() {
	save_path="${2-"$1/requirements.txt"}"
	if [ -z "$( command -v pipreqs )" ]; then
		alt "pipreqs not found. Do you want to install it?" "y" "n"
		if $alt_res; then
			pip install pipreqs
		else
			return 1
		fi
	fi
	pipreqs --savepath ~/.py_reqs.pyreqs --force "$1"
	pip freeze > ~/.py_reqs.freeze
	> $save_path
	while read p; do
		if [[ "$p" == *info ]]; then # ==info
			q=".egg"
			name=${p%$q*}
			echo "github install: $name"
			line=$( cat ~/.py_reqs.freeze | grep "\-e .*=$name" )
			echo "# $line" >> $save_path
		else
			echo "$p" >> $save_path
		fi
	done < ~/.py_reqs.pyreqs
	# remove tmp file
	rm -rf ~/.py_reqs.pyreqs
	rm -rf ~/.py_reqs.freeze
}

alias cd="env_cd"
