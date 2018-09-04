#!/bin/bash

dir_file="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
dir_home=$(realpath ~)

ln -snf "$dir_file/python/flake8" "$dir_home/.config/flake8"
ln -snf "$dir_file/python/pycodestyle" "$dir_home/.config/pycodestyle"

ln -snf "$dir_file/git/.gitconfig" "$dir_home/.gitconfig"

ln -snf "$dir_file/tmux/.tmux.conf" "$dir_home/.tmux.conf"

ln -snf "$dir_file/.inputrc" "$dir_home/.inputrc"

ln -snf "$dir_file/.toprc" "$dir_home/.toprc"

ln -snf "$dir_file/.Xresources" "$dir_home/.Xresources"
xrdb ~/.Xresources

ln -snf "$dir_file/terminator" "$dir_home/.config/terminator"

ln -snf "$dir_file/rxvt-unicode-256color" "$dir_home/.urxvt"

ln -snf "$dir_file/oh-my-zsh/.zshrc" "$dir_home/.zshrc"
ln -snf "$dir_file/oh-my-zsh/diegoximenes.zsh-theme" "$dir_home/.oh-my-zsh/themes/diegoximenes.zsh-theme"

# set default shell to zsh
sudo chsh -s "$(which zsh)"

if [ "$DESKTOP_SESSION" == "plasma" ]; then
    ln -snf "$dir_file/kde/kglobalshortcutsrc" "$dir_home/.config/kglobalshortcutsrc"
    # TODO: find how to reload configs without logout/reboot
    # sudo reboot
fi
