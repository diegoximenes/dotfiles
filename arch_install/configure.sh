#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

set -e
finish() {
    if [[ ! "$?" -eq 0 ]]; then
        echo -e "${RED}FAILED: ${BASH_COMMAND}${NC}"
    fi
}
trap finish EXIT

echo_step() {
    local step
    step="$1"
    echo -e "${BLUE}$step${NC}"
}

success() {
    echo -e "${GREEN}SUCCESS${NC}"
}

################################################################################

if [[ ! $# -eq 2 ]]; then
    echo "usage: bash configure.sh HOST_NAME USER"
    exit
fi

host_name="$1"
user="$2"

while true; do
    echo "HOST_NAME=$host_name"
    echo "USER=$user"
    read -r -p 'Proceed? (y/n): ' yn
    case "$yn" in
        y ) break;;
        n ) exit;;
        * ) echo 'Please answer y or n.';;
    esac
    echo ''
done

################################################################################

set_passwd() {
    local user_passwd
    user_passwd="$1"
    echo "Setting password for $user_passwd:"
    passwd "$user_passwd"
}

set_host() {
    echo "$host_name" > /etc/hostname
    echo -e "127.0.0.1 localhost\n::1 localhost\n127.0.1.1 $host_name.localdomain $host_name" > /etc/hosts
}

set_time_zone() {
    ln -sf /usr/share/zoneinfo/Brazil/East /etc/localtime
    hwclock --systohc
}

set_grub() {
    pacman -S grub efibootmgr dosfstools os-prober mtools
    mkdir /boot/EFI
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
    echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
    grub-mkconfig -o /boot/grub/grub.cfg
}

set_localization() {
    echo 'en_US.UTF-8 UTF-8  ' > /etc/locale.gen
    locale-gen
    echo 'LANG=en_US.UTF-8' > /etc/locale.conf
}

configure() {
    echo_step 'Configure the system...'
    set_time_zone
    set_localization
    set_host
    set_passwd root
    set_grub
}

################################################################################

post_install() {
    echo_step 'Post-installation...'
    useradd -m "$user"
    echo "$user ALL=(ALL) ALL" > /etc/sudoers.d/config
    set_passwd "$user"
}

################################################################################

configure
post_install
success
