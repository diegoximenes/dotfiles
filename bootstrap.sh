#!/bin/bash

dir_file="$(cd "$( dirname "${BASH_SOURCE[0]}")" && pwd)"
dir_home="$(realpath ~)"

ln -snf "$dir_file/.scripts" "$dir_home/.scripts"
ln -snf "$dir_file/.wallpapers" "$dir_home/.wallpapers"
ln -snf "$dir_file/.gitconfig" "$dir_home/.gitconfig"
ln -snf "$dir_file/.inputrc" "$dir_home/.inputrc"
ln -snf "$dir_file/.zshrc" "$dir_home/.zshrc"
ln -snf "$dir_file/.tmux.conf" "$dir_home/.tmux.conf"
ln -snf "$dir_file/tmux" "$dir_home/.tmux"

ln -snf "$dir_file/.config/"/* "$dir_home/.config/"
ln -snf "$dir_file/.oh-my-zsh/themes/"/* "$dir_home/.oh-my-zsh/themes/"

sudo ln -snf "$dir_file/systemd/"/* "/etc/systemd/"
sudo ln -snf "$dir_file/X11/xorg.conf.d"/* "/etc/X11/xorg.conf.d/"

sudo xdg-settings set default-web-browser google-chrome.desktop
