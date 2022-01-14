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

path_current_file="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
path_dotfiles="$(realpath "$path_current_file/..")"
path_home="$(realpath ~)"

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
    sudo chown -R root:root "$path_dotfiles/etc"
}

install_all() {
    echo_step "Syncing arch databases..."
    sudo pacman -Syy

    echo_step 'Installing pkglist.txt...'
    sudo pacman -S --needed --noconfirm - < "$path_dotfiles/packages/pkglist.txt"

    echo_step 'Installing yay...'
    if [[ ! "$(command -v yay)" ]]; then
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ..
        rm -rf yay
    fi

    echo_step 'Installing foreign_pkglist.txt...'
    yay -S --needed --noconfirm - < "$path_dotfiles/packages/foreign_pkglist.txt"
}

symlink() {
    echo_step 'Symlinking...'

    # ignores "." file
    find "$path_dotfiles/home" -maxdepth 1 -name '.*' -exec ln -snf {} "$path_home/" \;
    ln -snf "$path_dotfiles/config/"* "$path_home/.config/"
    mkdir -p "$path_home/.local/share/applications/"
    ln -snf "$path_dotfiles/local/share/applications/"* "$path_home/.local/share/applications/"
    mkdir -p "$path_home/.config/systemd/user/"
    ln -snf "$path_dotfiles/systemd/user/"* "$path_home/.config/systemd/user/"

    sudo mkdir -p /etc/systemd/resolved.conf.d
    # not sure why symlink don't work
    sudo cp "$path_dotfiles/etc/systemd/resolved.conf.d/resolved.conf" /etc/systemd/resolved.conf.d
    sudo ln -snf "$path_dotfiles/etc/systemd/logind.conf" /etc/systemd/

    sudo ln -snf "$path_dotfiles/etc/X11/xorg.conf.d/"* /etc/X11/xorg.conf.d/
    sudo ln -snf "$path_dotfiles/etc/NetworkManager/"* /etc/NetworkManager/
    sudo ln -snf "$path_dotfiles/etc/pacman.d/"* /etc/pacman.d/
}

set_zsh() {
    echo_step "Setting zsh..."
    if [[ "$(basename "$SHELL")" != "zsh" ]]; then
        chsh -s "$(command -v zsh)"
    fi

    zsh -i -c "antigen reset"
}

set_network_manager() {
    echo_step 'Setting NetworkManager...'
    sudo systemctl enable NetworkManager
}

set_systemd_resolved() {
    echo_step 'Setting systemd-resolved...'
    sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
    sudo systemctl enable systemd-resolved.service
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

set_bluetooth() {
    echo_step 'Setting bluetooth...'
    sudo systemctl enable bluetooth.service
}

set_tmux() {
    echo_step 'Setting tmux...'
    bash ~/.tmux/plugins/tpm/scripts/install_plugins.sh
}

opt="$1"

change_owner
[[ "$opt" == '--install' ]] && install_all
symlink
set_zsh
set_pkgfile
set_virtualbox
set_vnstat
set_bluetooth
set_tmux
# set network stuff, should be the last ones
set_network_manager
set_systemd_resolved
success
