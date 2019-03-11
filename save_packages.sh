#!/bin/bash

dir_file="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pacman -Qqen > "$dir_file/packages/pkglist.txt"
pacman -Qqem > "$dir_file/packages/foreign_pkglist.txt"
