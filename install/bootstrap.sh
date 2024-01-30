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
    find "$path_dotfiles/home" -maxdepth 1 -name '.*' -exec ln -snf {} "$HOME/" \;
    ln -snf "$path_dotfiles/config/"* "$HOME/.config/"
    mkdir -p "$HOME/.local/share/applications/"
    ln -snf "$path_dotfiles/local/share/applications/"* "$HOME/.local/share/applications/"

    sudo mkdir -p /etc/systemd/resolved.conf.d
    # not sure why symlink don't work
    sudo cp "$path_dotfiles/etc/systemd/resolved.conf.d/resolved.conf" /etc/systemd/resolved.conf.d
    sudo ln -snf "$path_dotfiles/etc/systemd/logind.conf" /etc/systemd/

    sudo ln -snf "$path_dotfiles/etc/X11/xorg.conf.d/"* /etc/X11/xorg.conf.d/
    sudo ln -snf "$path_dotfiles/etc/NetworkManager/"* /etc/NetworkManager/
    sudo ln -snf "$path_dotfiles/etc/pacman.d/"* /etc/pacman.d/
    sudo ln -snf "$path_dotfiles/etc/bluetooth/"* /etc/bluetooth/
}

generate_configs_dependent_on_screen() {
    echo_step 'Generating configs depedent on screen...'
    source "$HOME/.scripts/generate_configs_dependent_on_screen.sh"
}

install_yarn_packages() {
    echo_step 'Installing yarn packages...'
    yarn global add
}

install_go_binaries() {
    echo_step 'Installing go binaries...'
    go install github.com/nao1215/gup@latest
    go install github.com/bufbuild/buf-language-server/cmd/bufls@latest
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

set_vnstat() {
    echo_step 'Setting vnstat...'
    sudo systemctl enable vnstat.service
}

set_bluetooth() {
    echo_step 'Setting bluetooth...'
    sudo systemctl enable bluetooth.service
}

set_timesyncd() {
    echo_step 'Setting timesyncd...'
    sudo systemctl enable systemd-timesyncd.service
}

set_libvirtd() {
    echo_step 'Setting libvirtd...'
    sudo systemctl enable libvirtd.service

    sudo virsh net-autostart default
}

set_tmux() {
    echo_step 'Setting tmux...'
    bash ~/.tmux/plugins/tpm/scripts/install_plugins.sh
}

set_docker() {
    echo_step 'Setting docker...'
    sudo groupadd docker
    sudo usermod -aG docker "$USER"
}

change_owner

opt="$1"

if [[ "$opt" == '--symlink' ]]; then
    symlink
else
    [[ "$opt" == '--install' ]] && install_all
    symlink
    generate_configs_dependent_on_screen
    [[ "$opt" == '--install' ]] && install_yarn_packages
    [[ "$opt" == '--install' ]] && install_go_binaries
    set_pkgfile
    set_libvirtd
    set_vnstat
    set_bluetooth
    set_timesyncd
    set_tmux
    set_docker
    # set network stuff, should be the last ones
    set_network_manager
    set_systemd_resolved
fi

success
