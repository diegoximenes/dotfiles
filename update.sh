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

ssh_agent() {
    eval "$(ssh-agent)"
    ssh-add
}

update_submodules() {
    echo_step 'Updating submodules...'
    git submodule update --init --remote
    git submodule foreach 'git submodule update --init --recursive'
}

update_arch_packages() {
    echo_step 'Updating arch packages...'
    yay -Syu
}

remove_orphan_arch_packages() {
    echo_step 'Removing orphan arch packages...'
    sudo pacman -Rns "$(pacman -Qtdq)"
}

update_nvim() {
    echo_step 'Updating nvim stuff...'
    nvim +PlugUpdate
    nvim +PlugClean
    nvim +CocUpdate
}

update_tmux_plugins() {
    echo_step 'Updating tmux plugins...'
    ~/.tmux/plugins/tpm/bin/update_plugins all
}

ssh_agent
update_submodules
update_arch_packages
remove_orphan_arch_packages
update_nvim
update_tmux_plugins
success
