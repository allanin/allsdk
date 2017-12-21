#!/bin/bash

function copy_target () {
	rsync -a /root/allanin/build/ /root/allanin/target
}

function copy_kernel () {
	mount /dev/sda2 /root/allanin/kernel
	cp -a /root/allanin/kernel/gentoo /root/allanin/kernel/backup_gentoo
	cp -a /root/allanin/kernel/gentoo_initrd /root/allanin/kernel/backup_gentoo_initrd
	cp -a /root/allanin/boot/initramfs* /root/allanin/kernel/gentoo_initrd
	cp -a /root/allanin/boot/vmlinuz* /root/allanin/kernel/gentoo
	umount /dev/sda2
}

function umount_target () {
        umount /root/allanin/target
}

function sync_allanin () {
	umount_target
	mount /dev/sda6 /root/allanin/target
	copy_target
	copy_kernel
	umount_target
}

function sync_emunin () {
	umount_target
        mount /dev/sda5 /root/allanin/target
        copy_target
	copy_kernel
	umount_target
}

function sync_swayland () {
	umount_target
        mount /dev/sda5 /root/allanin/target
        copy_target
	copy_kernel
	umount_target
}


case "$1" in
        "sync-allanin")
                sync_allanin;
        ;;
        "sync-emunin")
                sync_emunin;
        ;;
        "sync-swayland")
                sync_swayland;
        ;;
        *)
        echo "You have failed to specify what to do correctly."
        exit 1
        ;;
esac

