#!/bin/bash

[[ "$(printf "no\nyes" | rofi -dmenu -i -p "$1" -theme gruvbox-light)" == "yes" ]] && $2
