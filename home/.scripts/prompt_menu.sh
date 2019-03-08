#!/bin/bash

[[ "$(printf "no\nyes" | rofi -dmenu -i -p "$1" -no-custom -theme gruvbox-light)" == "yes" ]] && $2
