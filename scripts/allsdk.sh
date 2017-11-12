#!/bin/bash

passwd -d root

eselect profile set 9

source /etc/profile
env-update
etc-update --automode -3
locale-gen

emerge dev-vcs/git
#emerge --sync
emerge -e --deep --with-bdeps=y --newuse @world
#emerge --sync
emerge --depclean
emerge =dev-lang/python-2.7.14
emerge linux-firmware ntfs3g wireless-tools

#ToDo for further using nfc
#emerge libnfc nfc-eventd

emerge retroarch allanin

#ToDo enable when wpa_supplicant does not python 2.7 anymore
#emerge -C =dev-lang/python-2.7.14

emerge gentoo-sources dracut
eselect news read

#mv /root/nfceventd.service /etc/systemd/system

mv /root/config /usr/src/linux/.config

#cd /usr/src/linux
#make -j 4 && make modules_install -j 4 && make install -j 4
#dracut --force

mkdir -p /storage/.cache/services/
mkdir /storage/roms
chown -R allanin:allanin /storage/


chmod 4755 /usr/bin/connmanctl
chmod 4755 /usr/bin/systemctl
chmod 4755 /sbin/shutdown

echo 'export PATH=$PATH:/sbin' >> /etc/profile

systemctl enable sshd
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
systemctl enable wpa_supplicant.service
systemctl enable bluetooth.service
systemctl enable allanin.service
#systemctl enable nfceventd.service
systemctl enable connman
systemctl enable devmon@allanin

hostnamectl set-hostname www.allanin.org

localectl set-locale LANG=de_DE.utf8
localectl set-keymap de-latin1-nodeadkeys

timedatectl set-local-rtc 0
timedatectl set-ntp true
timedatectl set-timezone 'Europe/Berlin'

systemd-machine-id-setup

connmanctl enable ethernet
connmanctl enable bluetooth
connmanctl enable wifi

echo ""
echo "Please change your password with passwd"
echo ""
passwd allanin
