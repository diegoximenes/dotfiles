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

install_pip3() {
    sudo pip3 install --upgrade pynvim # neovim
    sudo pip3 install --upgrade vim-vint # ale vim
    sudo pip3 install --upgrade flake8 python-language-server pycodestyle black # ale python
    sudo pip3 install --upgrade virtualenvwrapper
    sudo pip3 install --upgrade thefuck
    sudo pip3 install --upgrade i3ipc # i3
}

install_pip2() {
    sudo pip2 install --upgrade pynvim # neovim
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

    echo_step 'Installing pip2 packages...'
    install_pip2
    echo_step 'Installing pip3 packages...'
    install_pip3
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

set_pulseaudio() {
    echo_step 'Starting pulseaudio...'
    if ! pgrep -x 'pulseaudio' > /dev/null; then
        pulseaudio -D &
    fi
}

set_pkgfile() {
    echo_step 'Setting pkgfile...'
    sudo pkgfile --update
}

opt="$1"

[[ "$opt" == '--install' ]] && install_all
symlink
set_network_manager
set_pulseaudio
set_shell
set_pkgfile
success
