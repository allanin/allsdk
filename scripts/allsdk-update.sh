#!/bin/bash

function create_base () {
	emerge dev-vcs/git
	emerge --sync
	emerge -e --binpkg-changed-deps=y --binpkg-respect-use=y --deep --with-bdeps=y --newuse @world
	emerge --depclean
}

function prepare_chroot () {
	sed -i '/ROOT=/c\#ROOT=' /etc/portage/make.conf

	passwd -d root
	eselect profile set 22
	eselect python set 2

	source /etc/profile
	env-update
	etc-update --automode -3
	locale-gen
}

function create_allanin_base () {
	emerge --binpkg-changed-deps=y --binpkg-respect-use=y allanin-base
}

function create_allanin_emunin () {
	emerge --binpkg-changed-deps=y --binpkg-respect-use=y allanin-emunin
}

function create_allanin_swayland () {
        emerge --binpkg-changed-deps=y --binpkg-respect-use=y allanin-swayland
}

function build_kernel () {
	emerge gentoo-sources dracut
	cp /root/config /usr/src/linux/.config

	cd /usr/src/linux
	
	echo "Compiling kernel"
	make -j 4  >/dev/null 2>&1

	echo "Installing modules"
	make modules_install -j 4  >/dev/null 2>&1

	echo "Installing kernel"
	make install -j 4  >/dev/null 2>&1

	dracut --force
}

function download_files () {
	echo "Downloading files"

	prepare_chroot

	emerge -e --binpkg-changed-deps=y --binpkg-respect-use=y --deep --with-bdeps=y --newuse @world -f
	emerge --binpkg-changed-deps=y --binpkg-respect-use=y allanin-base -f
	emerge --binpkg-changed-deps=y --binpkg-respect-use=y allanin-emunin -f
	emerge --binpkg-changed-deps=y --binpkg-respect-use=y allanin-swayland -f
	emerge gentoo-sources dracut dev-vcs/git -f
}

function clean_up () {
	eselect news read
}

function create_allanin () {
        prepare_chroot;
        create_base;
        create_allanin_base;
        build_kernel;
        clean_up;
}

function create_emunin () {
	prepare_chroot;
	create_base;
	create_allanin_emunin;
	build_kernel;
	clean_up;
}

function create_swayland () {
        prepare_chroot;
        create_base;
        create_allanin_swayland;
        build_kernel;
        clean_up;
}

function create_packages () {
        prepare_chroot;
        create_base;
	create_allanin_emunin;
        create_allanin_swayland;
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
        "create-swayland")
                create_swayland;
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
        "download-files")
                download_files;
        ;;
        *)
        echo "You have failed to specify what to do correctly."
        exit 1
        ;;
esac

