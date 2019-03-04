#!/bin/bash

if [[ "$(printf "no\nyes" | rofi -dmenu -i -p "$1" -theme gruvbox-light)" == "yes" ]]; then
    $2
fi
