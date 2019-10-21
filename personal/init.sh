function mount-borg() {
    borg_dir=$1
    if [ -z "$borg_dir" ]; then
		echo 'please specify directory to mount borg'
		return
    fi
    if [ ! -d $borg_dir ]; then
        mkdir $borg_dir
    fi
    if [ "$(ls -A $borg_dir)" ]; then
        echo 'Directory $borg_dir is not empty. Aborted.'
    else
        sshfs -o cache=yes -o kernel_cache -o compression=no liyuc@dash-borg.usc.edu:/media/borg2/liyuc/ $borg_dir # Use -o Ciphers=arcfour when supported
    fi
}

function unmount-borg() {
    borg_dir=$1
    if [ -z "$borg_dir" ]; then
		echo 'please specify directory to mount borg'
		return
    fi
    if [ $OSTYPE = "linux-gnu" ]; then
        fusermount -u $borg_dir
    elif [ $OSTYPE == "darwin"* ]; then
        osxfuse -u $borg_dir
    fi
}
