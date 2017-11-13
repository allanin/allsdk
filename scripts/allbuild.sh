#!/bin/bash

#ToDo: Change make.conf for /build

rm -rf /build

mkdir /build
mkdir /build/dev
mkdir /build/proc
mkdir /build/sys
mkdir /build/tmp
chmod -R 777 /build/tmp
chmod +t /build/tmp

emerge baselayout
emerge -e --deep --with-bdeps=y --newuse @world
emerge =dev-lang/python-2.7.14
emerge linux-firmware ntfs3g openssh wireless-tools

emerge retroarch lakka

mkdir -p /build/storage/.cache/services/
mkdir /build/storage/roms
chown -R allanin:allanin /build/storage/

chmod 4755 /build/usr/bin/connmanctl
chmod 4755 /build/usr/bin/systemctl
chmod 4755 /build/sbin/shutdown

echo 'export PATH=$PATH:/sbin' >> /build/etc/profile

#etc
cp -a /etc/asound.conf /build/etc/
cp -a /etc/fstab /build/etc/
cp -a /etc/sudoers /build/etc/
cp -a /etc/passwd /build/etc/
cp -a /etc/shadow /build/etc/
cp -a /etc/gshadow /build/etc/
cp -a /etc/group /build/etc/
cp -a /etc/os-release /build/etc/
cp -a /etc/locale.gen /build/etc/

#systemd
cp -a /etc/systemd/timesyncd.conf /etc/systemd/timesyncd.conf

#modules
cp -a /lib/modules/ /build/lib/

#active services
#cd /build
#ln -s etc/systemd/system/multi-user.target.wants/sshd.service usr/lib/systemd/system/sshd.service
#ln -s etc/systemd/system/multi-user.target.wants/systemd-networkd.service usr/lib/systemd/system/systemd-networkd.service
#ln -s etc/systemd/system/sockets.target.wants/systemd-networkd.socket usr/lib/systemd/system/systemd-networkd.socket
#ln -s etc/systemd/system/dbus-fi.w1.wpa_supplicant1.service usr/lib/systemd/system/wpa_supplicant.service
#ln -s etc/systemd/system/multi-user.target.wants/wpa_supplicant.service usr/lib/systemd/system/wpa_supplicant.service
#ln -s etc/systemd/system/dbus-org.bluez.service usr/lib/systemd/system/bluetooth.service
#ln -s etc/systemd/system/bluetooth.target.wants/bluetooth.service usr/lib/systemd/system/bluetooth.service
#Created symlink /etc/systemd/system/allanin.target.wants/allanin.service → /etc/systemd/system/allanin.service.
#Created symlink /etc/systemd/system/multi-user.target.wants/connman.service → /usr/lib/systemd/system/connman.service.
#Created symlink /etc/systemd/system/multi-user.target.wants/devmon@allanin.service → /usr/lib/systemd/system/devmon@.service.

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
