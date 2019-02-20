#!/bin/bash

if [[ "$(printf "no\nyes" | dmenu -i -p "$1" -nb darkred -sb red -sf white -nf gray )" == "yes" ]]; then
    $2
fi
