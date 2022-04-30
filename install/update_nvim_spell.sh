#!/bin/bash

path_current_file="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
path_dotfiles="$(realpath "$path_current_file/..")"

delete_removed_words() {
    for spell_file in "$path_dotfiles/config/nvim/spell/"*.add; do
        sed -i "/^#/d" "$spell_file"
    done
}

delete_removed_words
