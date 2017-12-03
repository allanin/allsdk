#!/bin/bash

function enter_chroot() {
	bind_chroot;
	screen chroot ../../allanin /bin/bash
}

function create_chroot() {
	echo "Delete existing SDK structure"
#	deactivated for testing purposes
#	delete_structure;
#	create_structure;
#	deactivated for testing purposes
#	download_files;
	setup_files;
}

function update_chroot() {
	echo "Update chroot"
	cd ../../overlay/allanin
	git pull
	cd ../../overlay/emunin
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
echo "Deleting existing SDK files"

	rm -rf ../../allanin
	rm -rf ../../distfiles
	rm -rf ../../overlay
	rm -rf ../../packages
	rm -rf ../../portage
	rm -rf ../../stages
}

function download_files() {
	echo "Download SDK files"

	git clone https://github.com/allanin/allanin.git ../../overlay/allanin
	git clone https://github.com/allanin/emunin.git ../../overlay/emunin

	wget http://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64-systemd/stage3-amd64-systemd-20171123.tar.bz2  -P ../../stages/
}

function setup_files() {
	echo "Extract files for bootstrapping"
	
	tar xjpf ../../stages/stage3-amd64-systemd-20171123.tar.bz2 -C ../../allanin
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

	cp -a ../base/portage/allanin.conf ../../allanin/etc/portage/repos.conf/
	cp -a ../base/portage/emunin.conf ../../allanin/etc/portage/repos.conf/

	cp -a ../../portage ../../allanin/usr/

	#systemd
	cp -a ../base/systemd/timesyncd.conf ../../allanin/etc/systemd/timesyncd.conf

	#root
	cp -a allsdk-update.sh ../../allanin/root/
	cp -a allsdk-build.sh ../../allanin/root/

	#overlays
	cp -a ../../overlay/emunin ../../allanin/usr/local/overlay/
	cp -a ../../overlay/allanin ../../allanin/usr/local/overlay/

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
	"enter-chroot")
		enter_chroot;
	;;
	"update-chroot")
		update_chroot;
	;;
	"delete-chroot")
        	delete_chroot;
	;;
	*)
	echo "You have failed to specify what to do correctly."
	exit 1
    	;;
esac
