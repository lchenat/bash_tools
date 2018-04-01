#!/bin/bash

function send_ssh_key() {
	cat ~/.ssh/id_rsa.pub | ssh $1 "cat >> .ssh/authorized_keys"
}

# use this on other linux machine
function send_git_ssh_key() {
	scp ~/.ssh/id_rsa* $1:.ssh/
}
