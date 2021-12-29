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

if [[ ! $# -eq 4 ]]; then
    echo "usage: bash install.sh ARCH_PART SWAP_PART EFI_PART FORMAT_EFI_PART(y/n)"
    exit
fi

arch_part="$1"
swap_part="$2"
efi_part="$3"
format_efi_part="$4"

while true; do
    echo "ARCH_PART=$arch_part"
    echo "SWAP_PART=$swap_part"
    echo "EFI_PART=$efi_part"
    echo "FORMAT_EFI_PART=$format_efi_part (Warning: Only format the EFI system partition if you created it during the partitioning step. If there already was an EFI system partition on disk beforehand, reformatting it can destroy the boot loaders of other installed operating systems.)"
    read -r -p 'Proceed? (y/n): ' yn
    case "$yn" in
        y ) break;;
        n ) exit;;
        * ) echo 'Please answer y or n.';;
    esac
    echo ''
done

################################################################################

format_partitions() {
    mkfs.ext4 "$arch_part"
    mkswap "$swap_part"
    if [[ "$format_efi_part" == "y" ]]; then
        mkfs.fat -F 32 "$efi_part"
    fi
}

mount_partitions() {
    mount "$arch_part" /mnt
    mkdir /mnt/boot
    mount "$efi_part" /mnt/boot
    swapon "$swap_part"
}

pre_install() {
    echo_step 'Pre-installation...'
    timedatectl set-ntp true
    format_partitions
    mount_partitions
}

################################################################################

install() {
    echo_step 'Installation...'
    pacstrap /mnt base linux linux-firmware dhcpcd iwd git sudo
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

pre_install
install
configure
success
