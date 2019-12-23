function set-borg-path() {
	export borg_path=$( realpath $1 )
}

function get-borg-path() {
	echo $borg_path
}

function mount-borg() {
    borg_dir=$borg_path
    if [ -z "$borg_dir" ]; then
		echo 'please specify directory to mount borg'
		return
    fi
    if [ ! -d $borg_dir ]; then
        mkdir $borg_dir
    fi
	sshfs -o cache=no -o kernel_cache -o compression=no liyuc@dash-borg.usc.edu:/media/borg2/liyuc/ $borg_dir # Use -o Ciphers=arcfour when supported
}

function unmount-borg() {
    borg_dir=$borg_path
    if [ -z "$borg_dir" ]; then
		echo 'please specify directory to mount borg'
		return
    fi
    # Terminal Themes
    if [ $OSTYPE = "linux-gnu" ]; then
        fusermount -zu $borg_dir
    elif [ $OSTYPE == "darwin"* ]; then
		umount -f $borg_dir
    fi
}

function refresh-borg() {
	cd ~
	unmount-borg
	#rm -rf $borg_path/*
	mount-borg
	cd -
}
