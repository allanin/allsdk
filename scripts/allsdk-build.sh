#!/bin/bash

function create_build () {
	sed -i '/#ROOT=/c\ROOT="/build"' /etc/portage/make.conf
	emerge baselayout
	emerge -e --deep --with-bdeps=y --newuse @world
	emerge =dev-lang/python-2.7.14
	emerge linux-firmware ntfs3g openssh wireless-tools
	emerge retroarch allanin
}

function prepare_build () {
	rm -rf /build
	mkdir /build
	mkdir /build/dev
	mkdir /build/proc
	mkdir /build/sys
	mkdir /build/tmp
	mkdir -p /build/storage/.cache/services/
	mkdir /build/storage/roms

	chmod -R 777 /build/tmp
	chmod +t /build/tmp
	chown -R allanin:allanin /build/storage/
}

function copy_configs () {
	cp -a /etc/asound.conf /build/etc/
	cp -a /etc/fstab /build/etc/
	cp -a /etc/sudoers /build/etc/
	cp -a /etc/passwd /build/etc/
	cp -a /etc/shadow /build/etc/
	cp -a /etc/gshadow /build/etc/
	cp -a /etc/group /build/etc/
	cp -a /etc/os-release /build/etc/
	cp -a /etc/locale.gen /build/etc/

	cp -a /etc/systemd/timesyncd.conf /etc/systemd/timesyncd.conf
}

function copy_modules () {
	cp -a /lib/modules/ /build/lib/
}

function clean_build () {
	emerge --unmerge gcc
	emerge --unmerge portage
	emerge --unmerge gcc-config
	emerge --unmerge make
	emerge --unmerge patch
	emerge --unmerge man
	emerge --unmerge man-pages
	emerge --unmerge man-pages-posix
	emerge --unmerge binutils
	emerge --unmerge binutils-config
	emerge --unmerge gnuconfig
}

function adjust_permissions () {
	chmod 4755 /build/usr/bin/connmanctl
	chmod 4755 /build/usr/bin/systemctl
	chmod 4755 /build/sbin/shutdown

	echo 'export PATH=$PATH:/sbin' >> /build/etc/profile
}

function create_allanin () {
	remove_allanin;
	prepare_build;
	create_build;
	copy_configs;
	copy_modules;
	clean_build;
	adjust_permissions;
	activate_services;
}

function remove_allanin () {
	rm -rf /build
}

case "$1" in
        "create-allanin")
                create_allanin;
        ;;
        "remove-allanin")
                remove_allanin;
        ;;
        *)
        echo "You have failed to specify what to do correctly."
        exit 1
        ;;
esac
