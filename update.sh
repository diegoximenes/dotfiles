#!/bin/bash

yay -Syu
sudo pacman -Syu

# remove orphan packages
sudo pacman -Rns "$(pacman -Qtdq)"

eval "$(ssh-agent)"
ssh-add
