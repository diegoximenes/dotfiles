#!/bin/bash

if [[ ! $# -eq 4 ]]; then
    echo "usage: bash arch_install.sh HOST_NAME ARCH_PART SWAP_PART USER"
    exit
fi

host_name="$1"
arch_part="$2"
swap_part="$3"
user="$4"

while true; do
    echo "HOST_NAME=$host_name"
    echo "ARCH_PART=$arch_part"
    echo "SWAP_PART=$swap_part"
    echo "USER=$user"
    read -p 'Proceed? (y/n): ' yn
    case "$yn" in
        y ) break;;
        n ) exit;;
        * ) echo 'Please answer y or n.';;
    esac
    echo ''
done

arch_disk="$(echo "$arch_part" | tr -d '[:digit:]')"

################################################################################

format_disk() {
    mkfs.ext4 "$arch_part"
    mkswap "$swap_part"
    swapon "$swap_part"
}

pre_install() {
    echo 'Pre-installation...'
    loadkeys br-abnt2
    timedatectl set-ntp true
    format_disk
    mount "$arch_part" /mnt
}

################################################################################

install() {
    echo 'Installation...'
    pacstrap /mnt base wpa_supplicant grub git sudo
}

################################################################################

set_host() {
    echo "$host_name" > /etc/hostname
    echo -e "127.0.0.1 localhost\n::1 localhost\n127.0.1.1 $host_name.localdomain $host_name" > /etc/hosts
}

set_fstab() {
    genfstab -U /mnt >> /mnt/etc/fstab
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
    set_fstab
    arch-chroot /mnt
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

pre_install
install
configure
post_install
reboot
