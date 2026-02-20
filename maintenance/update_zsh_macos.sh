#!/bin/bash

# This script updates zsh related stuff

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

check_zsh() {
    local script_shell
    script_shell="$(readlink /proc/$$/exe | sed "s/.*\///")"
    if [[ "$script_shell" != "zsh" ]]; then
        echo -e "${RED}FAILED: script must be run with zsh${NC}"
        exit 1
    fi
}
check_zsh

echo_step() {
    local step
    step="$1"
    echo -e "${BLUE}$step${NC}"
}

success() {
    echo -e "${GREEN}SUCCESS${NC}"
}

# specific for zsh
TRAPEXIT() {
    if [[ ! "$?" -eq 0 ]]; then
        echo -e "${RED}FAILED${NC}"
    fi
}

source "$HOME/.zshrc"

update_nvm() {
    echo_step 'Updating nvm...'
    nvm upgrade
}

update_antigen() {
    echo_step 'Updating antigen...'
    antigen update
}

update_antigen
update_nvm
success
