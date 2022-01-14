#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

finish() {
    if [[ ! "$?" -eq 0 ]]; then
        echo -e "${RED}FAILED: ${BASH_COMMAND}${NC}"
        exit 1
    fi
}
set -e
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
    yay -Syu --answerupgrade None --answerclean All --answerdiff None --removemake --noconfirm
}

remove_orphan_arch_packages() {
    echo_step 'Removing orphan arch packages...'

    local packages_to_remove
    set +e
    trap "" EXIT
    # this command exits with non zero code if the result is empty
    packages_to_remove="$(pacman -Qtdq)"
    set -e
    trap finish EXIT
    if [[ ! "$?" -eq 0 ]] && [[ "$packages_to_remove" != "" ]]; then
        finish
    fi
    if [[ "$packages_to_remove" != "" ]]; then
        sudo pacman -Rns $packages_to_remove --noconfirm
    fi
}

update_vim_plug() {
    curl -fLo ~/.config/nvim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

update_nvim() {
    echo_step 'Updating nvim stuff...'

    update_vim_plug

    nvim +PlugUpdate
    nvim +PlugClean
}

update_tmux_plugins() {
    echo_step 'Updating tmux plugins...'
    ~/.tmux/plugins/tpm/bin/update_plugins all
}

update_nvm() {
    echo_step 'Updating nvm...'
    nvm upgrade
}

ssh_agent
update_submodules
update_arch_packages
remove_orphan_arch_packages
update_nvim
update_tmux_plugins
update_nvm
success
