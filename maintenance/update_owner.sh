#!/bin/bash

path_current_file="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
path_dotfiles="$(realpath "$path_current_file/..")"

update_owner() {
    local root_files
    root_files=$(ls -a -I etc -I . -I .. "$path_dotfiles")
    for root_file in $root_files; do
        sudo chown -R "$USER" "$path_dotfiles/$root_file"
    done
}

update_owner
