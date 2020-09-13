#!/bin/bash

yay -Syu

# remove orphan packages
sudo pacman -Rns "$(pacman -Qtdq)"

eval "$(ssh-agent)"
ssh-add

nvim +PlugUpdate
nvim +PlugClean
nvim +CocUpdate
