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
    echo "usage: bash arch_install.sh ARCH_PART SWAP_PART"
    exit
fi

arch_part="$1"
swap_part="$2"

while true; do
    echo "ARCH_PART=$arch_part"
    echo "SWAP_PART=$swap_part"
    read -p 'Proceed? (y/n): ' yn
    case "$yn" in
        y ) break;;
        n ) exit;;
        * ) echo 'Please answer y or n.';;
    esac
    echo ''
done

################################################################################

format_disk() {
    mkfs.ext4 "$arch_part"
    mkswap "$swap_part"
    swapon "$swap_part"
}

pre_install() {
    echo_step 'Pre-installation...'
    loadkeys br-abnt2
    timedatectl set-ntp true
    format_disk
    mount "$arch_part" /mnt
}

################################################################################

install() {
    echo_step 'Installation...'
    pacstrap /mnt base wpa_supplicant grub git sudo
}

################################################################################

set_fstab() {
    genfstab -U /mnt >> /mnt/etc/fstab
}

configure() {
    echo_step 'Configure the system...'
    set_fstab
}

################################################################################

post_install() {
    echo_step 'Post-installation...'
    useradd -m -G sudo "$user"
    passwd "$user"
}

################################################################################

pre_install
install
configure
success
