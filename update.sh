#!/bin/bash

sudo yay -Syu
sudo pacman -Syu

# remove orphan packages
sudo pacman -Rns "$(pacman -Qtdq)"

nvim +PlugUpdate +PlugClean +CocUpdate
