#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

set -e
finish() {
    if [[ ! "$?" -eq 0 ]]; then
        echo -e "${RED}FAILED: ${BASH_COMMAND}${NC}"
    fi
}
trap finish EXIT

echo_step() {
    local step
    step="$1"
    echo -e "${BLUE}$step${NC}"
}

success() {
    echo -e "${GREEN}SUCCESS${NC}"
}

################################################################################

FIRST_LINE="checking for file conflicts..."
LAST_LINE="Errors occurred, no packages were upgraded."

get_package_from_line() {
    local line
    line="$1"

    IFS=':'
    local splitted
    read -ra splitted <<< "$line"
    IFS=' '
    echo "${splitted[0]}"
}

main() {
    echo_step "Reading packages with conflict..."

    local add_to_set
    add_to_set=0

    local packages_set
    declare -A packages_set

    local packages
    packages=""

    while read -r line; do
        if [[ "$line" == "$LAST_LINE" ]]; then
            for package in "${!packages_set[@]}"; do
                packages="$packages $package"
            done

            echo_step "Reinstalling packages$packages..."
            sudo pacman -S --force --noconfirm $packages
        elif [[ $add_to_set == 1 ]]; then
            package="$(get_package_from_line "$line")"
            packages_set["$package"]=1
        elif [[ "$line" == "$FIRST_LINE" ]]; then
            add_to_set=1
        fi
    done
}

main
success
