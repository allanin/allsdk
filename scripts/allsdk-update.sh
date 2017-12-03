#!/bin/bash

function create_base () {
	emerge dev-vcs/git
#	emerge --sync
	emerge -e --binpkg-changed-deps=y --binpkg-respect-use=y --deep --with-bdeps=y --newuse @world
#	emerge --sync
	emerge --depclean
	emerge linux-firmware ntfs3g wireless-tools
}

function prepare_chroot () {
	sed -i '/ROOT=/c\#ROOT=' /etc/portage/make.conf

	passwd -d root
	eselect profile set 9
	eselect python set 2

	source /etc/profile
	env-update
	etc-update --automode -3
	locale-gen
}

function create_allanin () {
	emerge --binpkg-changed-deps=y --binpkg-respect-use=y allanin
}

function create_emunin () {
	emerge --binpkg-changed-deps=y --binpkg-respect-use=y allanin retroarch
}

function build_kernel () {
	emerge gentoo-sources dracut
	cp /root/config /usr/src/linux/.config

	cd /usr/src/linux
	make -j 4 && make modules_install -j 4 && make install -j 4
	dracut --force
}

function clean_up () {
	eselect news read
}

function create_packages () {
	prepare_chroot;
	create_base;
	create_allanin;
	build_kernel;
	clean_up;
}

function update_packages () {
	emerge -uND world;
	clean_up;
}

case "$1" in
        "create-base")
                create_base;
        ;;
        "prepare-chroot")
                prepare_chroot;
        ;;
        "create-allanin")
                create_allanin;
        ;;
        "create-emunin")
                create_emunin;
        ;;
        "build-kernel")
                build_kernel;
        ;;
        "create-packages")
                create_packages;
        ;;
        "update-packages")
                update_packages;
        ;;
        *)
        echo "You have failed to specify what to do correctly."
        exit 1
        ;;
esac

