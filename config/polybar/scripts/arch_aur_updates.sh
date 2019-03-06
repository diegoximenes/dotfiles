#!/bin/bash

updates_arch="$(checkupdates 2> /dev/null | wc -l)"
updates_aur="$(yay -Qum 2> /dev/null | wc -l)"
updates="$(("$updates_arch" + "$updates_aur"))"

if [[ "$updates" -gt 0 ]]; then
    echo "♻ $updates"
else
    echo ""
fi
