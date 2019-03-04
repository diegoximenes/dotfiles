#!/bin/bash

dir_file="$(cd "$( dirname "${BASH_SOURCE[0]}")" && pwd)"
dir_home="$(realpath ~)"

ln -snf "$dir_file/home/".* "$dir_home/"
ln -snf "$dir_file/config/"* "$dir_home/.config/"
ln -snf "$dir_file/oh-my-zsh/themes/"* "$dir_home/.oh-my-zsh/themes/"

sudo ln -snf "$dir_file/systemd/"* "/etc/systemd/"
sudo ln -snf "$dir_file/X11/xorg.conf.d"* "/etc/X11/xorg.conf.d/"

sudo xdg-settings set default-web-browser google-chrome.desktop
