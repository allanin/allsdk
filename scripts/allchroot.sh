#!/bin/bash
#Basis fuer die Binary, Build und Gaming Umgebung fuer allanin.

echo "Create structure for sdk"
mkdir -p ../../distfiles  
mkdir -p ../../overlay
mkdir -p ../../packages
mkdir -p ../../portage  
mkdir -p ../../stages

mkdir -p ../../allanin

#bootstrap
echo "Extract files for bootstrapping"
tar xjpf ../../stages/stage3-amd64-systemd-20171028.tar.bz2 -C ../../allanin
mkdir -p ../../allanin/usr/local/overlay
mkdir ../../allanin/etc/portage/repos.conf

echo "Mounting required directories"
mount -o rbind /dev ../../allanin/dev > /dev/null &
mount -t proc none ../../allanin/proc > /dev/null &
mount -o bind /sys ../../allanin/sys > /dev/null &
mount -o bind /tmp ../../allanin/tmp > /dev/null &

# etc
echo "Copy required config files"
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

#portage
cp -a ../base/portage/make.conf ../../allanin/etc/portage/
cp -a ../base/portage/package.accept_keywords ../../allanin/etc/portage/
cp -a ../base/portage/package.use ../../allanin/etc/portage/

cp -a ../base/portage/allanin.conf ../../allanin/etc/portage/repos.conf/
cp -a ../base/portage/emunin.conf ../../allanin/etc/portage/repos.conf/

#systemd
cp -a ../base/systemd/timesyncd.conf ../../allanin/etc/systemd/timesyncd.conf

#root (SDK)
#Ueber overlay in Zukunft einbinden
cp -a allsdk.sh ../../allanin/root/
cp -a allbuild.sh ../../allanin/root/
cp -a ../base/linux/config ../../allanin/root/

#distfiles
echo "Copy portage files"
cp -a ../../portage ../../allanin/usr/

#overlay
echo "Copy overlay files"
cp -a ../../overlay/allanin ../../allanin/usr/local/overlay/
cp -a ../../overlay/emunin ../../allanin/usr/local/overlay/

#distfiles
echo "Copy portage distfiles"
cp -a ../../distfiles ../../allanin/usr/portage/

#distfiles
echo "Copy portage packages"
cp -a ../../packages ../../allanin/usr/portage/

echo "Entering chroot"
screen chroot ../../allanin /bin/bash
