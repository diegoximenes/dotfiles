#!/bin/bash

dir_file="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
dir_home=$(realpath ~)

ln -snf $dir_file/.bashrc $dir_home/.bashrc

ln -snf $dir_file/tmux/.tmux.conf $dir_home/.tmux.conf

ln -snf $dir_file/.inputrc $dir_home/.inputrc

ln -snf $dir_file/.Xresources $dir_home/.Xresources
xrdb ~/.Xresources

ln -snf $dir_file/rxvt-unicode-256color $dir_home/.urxvt

ln -snf $dir_file/oh-my-zsh/.zshrc $dir_home/.zshrc
ln -snf $dir_file/oh-my-zsh/my_gentoo.zsh-theme $dir_home/.oh-my-zsh/themes/my_gentoo.zsh-theme
