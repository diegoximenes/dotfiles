#!/bin/bash

dir_file="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

brew list > "$dir_file/brew_list"
brew list --formula > "$dir_file/brew_list_formula"
