#!/bin/bash

if [[ ! $# -eq 3 ]]; then
    echo "usage: bash arch_install.sh GRUB_DISK HOST_NAME USER"
    exit
fi

grub_disk="$1"
host_name="$2"
user="$3"

while true; do
    echo "GRUB_DISK=$grub_disk"
    echo "HOST_NAME=$host_name"
    echo "USER=$user"
    read -p 'Proceed? (y/n): ' yn
    case "$yn" in
        y ) break;;
        n ) exit;;
        * ) echo 'Please answer y or n.';;
    esac
    echo ''
done

################################################################################

set_host() {
    echo "$host_name" > /etc/hostname
    echo -e "127.0.0.1 localhost\n::1 localhost\n127.0.1.1 $host_name.localdomain $host_name" > /etc/hosts
}

set_time_zone() {
    ln -sf /usr/share/zoneinfo/Brazil/East /etc/localtime
    hwclock --systohc
}

set_grub() {
    grub-install --target=i386-pc "$arch_disk"
    grub-mkconfig -o /boot/grub/grub.cfg
}

set_localization() {
    echo 'en_US.UTF-8 UTF-8  ' > /etc/locale.gen
    locale-gen
    echo 'LANG=en_US.UTF-8' > /etc/locale.conf
    echo 'KEYMAP=br-abnt2' > /etc/vconsole.conf
}

configure() {
    echo 'Configure the system...'
    set_time_zone
    set_localization
    set_host
    passwd
    set_grub
}

################################################################################

post_install() {
    echo 'Post-installation...'
    useradd -m -G sudo "$user"
    passwd "$user"
}

################################################################################

configure
post_install
reboot
