#!/bin/bash

dir_file="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pacman -Qqen > "$dir_file/pkglist.txt"
pacman -Qqem > "$dir_file/foreign_pkglist.txt"
