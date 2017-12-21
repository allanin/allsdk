#!/bin/bash

function create_system () {
	emerge baselayout
	emerge openssh
	emerge -e --deep --with-bdeps=y --newuse @system
}

function create_allanin_base () {
        emerge allanin-base
}

function create_allanin_emunin () {
        emerge allanin-emunin
}

function create_allanin_swayland () {
        emerge allanin-swayland
}

function prepare_build () {
	rm -rf /target
	mkdir /target

	rm -rf /kernel
	mkdir /kernel

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

	sed -i '/#ROOT=/c\ROOT="/build"' /etc/portage/make.conf
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

function activate_services () {
	echo "ToDo"
}

function remove_build () {
        rm -rf /build
}

function create_allanin () {
	remove_build;
	prepare_build;
	create_system;
	create_allanin_base;
	copy_configs;
	copy_modules;
	clean_build;
	adjust_permissions;
	activate_services;
}

function create_emunin () {
        remove_build;
        prepare_build;
        create_system;
        create_allanin_emunin;
        copy_configs;
        copy_modules;
        clean_build;
        adjust_permissions;
        activate_services;
}

function create_swayland () {
        remove_build;
        prepare_build;
        create_system;
        create_allanin_swayland;
        copy_configs;
        copy_modules;
        clean_build;
        adjust_permissions;
        activate_services;
}

case "$1" in
        "create-allanin")
                create_allanin;
        ;;
        "create-emunin")
                create_emunin;
        ;;
        "create-swayland")
                create_swayland;
        ;;
        "remove-allanin")
                remove_build;
        ;;
        *)
        echo "You have failed to specify what to do correctly."
        exit 1
        ;;
esac
