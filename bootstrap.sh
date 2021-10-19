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

dir_file="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dir_home="$(realpath ~)"

echo_step() {
    local step
    step="$1"
    echo -e "${BLUE}$step${NC}"
}

success() {
    echo -e "${GREEN}SUCCESS${NC}"
}

change_owner() {
    echo_step 'Changing owner...'
    sudo chown -R root:root "$dir_file/etc"
}

install_all() {
    echo_step 'Installing pkglist.txt...'
    sudo pacman -S --needed --noconfirm - < "$dir_file/packages/pkglist.txt"

    echo_step 'Installing yay...'
    if [[ ! "$(command -v yay)" ]]; then
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ..
        rm -rf yay
    fi

    echo_step 'Installing foreign_pkglist.txt...'
    yay -S --needed --noconfirm - < "$dir_file/packages/foreign_pkglist.txt"
}

symlink() {
    echo_step 'Symlinking...'

    # ignores "." file
    find "$dir_file/home" -maxdepth 1 -name '.*' -exec ln -snf {} "$dir_home/" \;
    ln -snf "$dir_file/config/"* "$dir_home/.config/"
    ln -snf "$dir_file/oh-my-zsh/custom/themes/"* "$dir_home/.oh-my-zsh/custom/themes/"
    ln -snf "$dir_file/oh-my-zsh/custom/plugins/"* "$dir_home/.oh-my-zsh/custom/plugins/"
    mkdir -p "$dir_home/.local/share/applications/"
    ln -snf "$dir_file/local/share/applications/"* "$dir_home/.local/share/applications/"
    mkdir -p "$dir_home/.config/systemd/user/"
    ln -snf "$dir_file/systemd/user/"* "$dir_home/.config/systemd/user/"

    sudo ln -snf "$dir_file/etc/resolv.conf" /etc/resolv.conf
    sudo ln -snf "$dir_file/etc/systemd/"* /etc/systemd/
    sudo ln -snf "$dir_file/etc/X11/xorg.conf.d/"* /etc/X11/xorg.conf.d/
    sudo ln -snf "$dir_file/etc/NetworkManager/"* /etc/NetworkManager/
    sudo ln -snf "$dir_file/etc/pacman.d/"* /etc/pacman.d/
}

set_shell() {
    echo_step "Setting zsh as the default shell..."
    if [[ "$(basename "$SHELL")" != "zsh" ]]; then
        chsh -s "$(command -v zsh)"
    fi
}

set_network_manager() {
    echo_step 'Enabling NetworkManager...'
    sudo systemctl enable NetworkManager
}

set_pkgfile() {
    echo_step 'Setting pkgfile...'
    sudo pkgfile --update
}

set_virtualbox() {
    echo_step 'Setting virtualbox...'
    sudo modprobe --verbose --force-vermagic vboxdrv
}

set_vnstat() {
    echo_step 'Setting vnstat...'
    sudo systemctl enable vnstat.service
}

set_dropbox() {
    echo_step 'Setting dropbox...'
    systemctl --user enable dropbox
}

set_bluetooth() {
    echo_step 'Enabling bluetooth...'
    sudo systemctl enable bluetooth.service
}

opt="$1"

change_owner
[[ "$opt" == '--install' ]] && install_all
symlink
set_network_manager
set_shell
set_pkgfile
set_virtualbox
set_vnstat
set_dropbox
set_bluetooth
success
