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

    echo_step 'Installing pip.txt...'
    sudo pip install -r "$dir_file/packages/pip.txt"
    echo_step 'Installing pip2.txt...'
    sudo pip2 install -r "$dir_file/packages/pip2.txt"

    echo_step 'Installing oh-my-zsh...'
    if [[ ! -d "$dir_home/.oh-my-zsh" ]]; then
        git clone https://github.com/robbyrussell/oh-my-zsh "$dir_home/.oh-my-zsh"
    fi
}

symlink() {
    echo_step 'Symlinking...'

    # ignores "." file
    find "$dir_file/home" -maxdepth 1 -name '.*' -exec ln -snf {} "$dir_home/" \;
    ln -snf "$dir_file/config/"* "$dir_home/.config/"
    ln -snf "$dir_file/oh-my-zsh/themes/"* "$dir_home/.oh-my-zsh/themes/"
    ln -snf "$dir_file/local/share/applications/"* "$dir_home/.local/share/applications/"

    sudo ln -snf "$dir_file/etc/systemd/"* /etc/systemd/
    sudo ln -snf "$dir_file/etc/X11/xorg.conf.d"* /etc/X11/xorg.conf.d/
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

set_wallpaper() {
    echo_step 'Configuring wallpaper...'
    betterlockscreen -u "$dir_home/.wallpapers/tarantino.jpg"
}

set_pulseaudio() {
    echo_step 'Starting pulseaudio...'
    if ! pgrep -x 'pulseaudio' > /dev/null; then
        pulseaudio -D
    fi
}

set_cron() {
    echo_step 'Setting cron...'
    crontab "$dir_file/crontab.txt"
    systemctl enable cronie.service
}

install_yarn_packages() {
    echo_step 'Installing yarn packages...'
    yarn global add
}

install_all
symlink
install_yarn_packages
set_wallpaper
set_network_manager
set_pulseaudio
set_cron
set_shell
success
