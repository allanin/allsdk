#!/bin/bash

function enter_chroot() {
	echo "Entering chroot"

	bind_chroot;
	screen chroot ../../allanin /bin/bash
}

function create_chroot() {
	echo "Delete existing SDK structure"

	delete_structure;
	create_structure;
	download_files;
	setup_files;
}

function setup_chroot() {
	echo "Setup existing SDK structure"

	delete_allanin;
	create_structure;
	setup_files;	
}

function update_chroot() {
	echo "Update chroot"

	cd ../../overlay/allanin-base
	git pull
}

function bind_chroot() {
	echo "Mounting required directories"
	mount -o rbind /dev ../../allanin/dev > /dev/null &
	mount -t proc none ../../allanin/proc > /dev/null &
	mount -o bind /sys ../../allanin/sys > /dev/null &
	mount -o bind /tmp ../../allanin/tmp > /dev/null &
}

function create_structure() {
	echo "Create structure for sdk"

	mkdir -p ../../distfiles
	mkdir -p ../../overlay
	mkdir -p ../../packages
	mkdir -p ../../portage
	mkdir -p ../../stages
	mkdir -p ../../allanin
}

function delete_structure() {
	echo "Deleting existing SDK directories"

	rm -rf ../../allanin
	rm -rf ../../distfiles
	rm -rf ../../overlay
	rm -rf ../../packages
	rm -rf ../../portage
	rm -rf ../../stages
}

function delete_allanin() {
	echo "Deleting existing allanin directory"
	
	rm -rf ../../allanin
}

function download_files() {
	echo "Download SDK files"

	git clone https://github.com/allanin/allanin.git ../../overlay/allanin-base

	wget http://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64-systemd/stage3-amd64-systemd-20171213.tar.bz2 -P ../../stages/
}

function setup_files() {
	echo "Extract files for bootstrapping"
	
	tar xjpf ../../stages/stage3-amd64-systemd-20171213.tar.bz2 -C ../../allanin
	mkdir -p ../../allanin/usr/local/overlay
	mkdir ../../allanin/etc/portage/repos.conf

	echo "Copy required config files"

	#etc
	cp -a ../base/etc/asound.conf ../../allanin/etc/
	cp -a ../base/etc/fstab ../../allanin/etc/
	cp -a ../base/etc/dracut.conf ../../allanin/etc/
	cp -a ../base/etc/sudoers ../../allanin/etc/
	cp -a ../base/etc/passwd ../../allanin/etc/
	cp -a ../base/etc/shadow ../../allanin/etc/
	cp -a ../base/etc/gshadow ../../allanin/etc/
	cp -a ../base/etc/group ../../allanin/etc/
	cp -a ../base/etc/os-release ../../allanin/etc/
	cp -a ../base/etc/locale.gen ../../allanin/etc/

	cp -a ../base/etc/blacklist.conf ../../allanin/etc/modprobe.d/

	#kernel
	cp -a  ../base/linux/config ../../allanin/root/

	#portage
	cp -a ../base/portage/make.conf ../../allanin/etc/portage/
	cp -a ../base/portage/package.accept_keywords ../../allanin/etc/portage/
	cp -a ../base/portage/package.use ../../allanin/etc/portage/
	cp -a ../base/portage/package.license ../../allanin/etc/portage/

	cp -a ../base/portage/allanin-base.conf ../../allanin/etc/portage/repos.conf/

	cp -a ../../portage ../../allanin/usr/

	#systemd
	cp -a ../base/systemd/timesyncd.conf ../../allanin/etc/systemd/timesyncd.conf

	#root
	cp -a allsdk-update.sh ../../allanin/root/
	cp -a allsdk-build.sh ../../allanin/root/

	#overlays
	cp -a ../../overlay/allanin-base ../../allanin/usr/local/overlay/

	#distfiles
	echo "Copy portage distfiles"
	cp -a ../../distfiles ../../allanin/usr/portage/distfiles

	#packages
	echo "Copy portage packages"
	cp -a ../../packages ../../allanin/usr/portage/
	}

case "$1" in
	"create-chroot")
        	create_chroot;
    	;;
	"setup-chroot")
		setup_chroot;
	;;
	"enter-chroot")
		enter_chroot;
	;;
	"update-chroot")
		update_chroot;
	;;
	"delete-chroot")
        	delete_chroot;
	;;
        "delete-allanin")
                delete_allanin;
        ;;
	*)
	echo "You have failed to specify what to do correctly."
	exit 1
    	;;
esac
