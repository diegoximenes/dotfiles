#!/bin/bash

dir_file="$(cd "$( dirname "${BASH_SOURCE[0]}")" && pwd)"
dir_home="$(realpath ~)"

install_all() {
    if [[ ! "$(command -v yay)" ]]; then
        echo "Installing yay..."
        git clone https://aur.archlinux.org/yay.git
        (cd yay && makepkg -si)
        rm -rf yay
    fi

    echo "Installing pkglist.txt..."
    sudo pacman -S --needed - < "$dir_file/packages/pkglist.txt"

    echo "Installing foreignpkglist.txt..."
    yay -S --needed - < "$dir_file/packages/foreign_pkglist.txt"

    echo "Installing pip.txt..."
    sudo pip install -r "$dir_file/packages/pip.txt"

    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

symlink() {
    echo "Symlinking..."

    ln -snf "$dir_file/home/".* "$dir_home/"
    ln -snf "$dir_file/config/"* "$dir_home/.config/"
    ln -snf "$dir_file/oh-my-zsh/themes/"* "$dir_home/.oh-my-zsh/themes/"

    sudo ln -snf "$dir_file/systemd/"* "/etc/systemd/"
    sudo ln -snf "$dir_file/X11/xorg.conf.d"* "/etc/X11/xorg.conf.d/"
}

network_manager() {
    echo "Starting NetworkManager..."
    sudo systemctl start NetworkManager
    sudo systemctl enable NetworkManager
}

wallpaper() {
    "Configuring wallpaper..."
    betterlockscreen -u ~/.wallpapers/tarantino.jpg
}

install_all
wallpaper
network_manager
