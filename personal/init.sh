function mount-borg() {
    borg_dir=$1
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
    borg_dir=$1
    if [ -z "$borg_dir" ]; then
		echo 'please specify directory to mount borg'
		return
    fi
	umount -f $borg_dir
}
