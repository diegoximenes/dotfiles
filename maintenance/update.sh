#!/bin/bash

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

# specific for zsh
path_current_file="$(cd "$(dirname "${0:a}")" && pwd)"
path_dotfiles="$path_current_file/.."

source "$HOME/.zshrc"

ssh_agent() {
    eval "$(ssh-agent)"
    ssh-add
}

update_submodules() {
    echo_step 'Updating submodules...'
    git submodule update --remote --merge
}

update_arch_packages() {
    echo_step 'Updating arch packages...'
    sudo pacman -Sy archlinux-keyring --noconfirm
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
        echo "$packages_to_remove" | sudo pacman -Rns --noconfirm -
    fi
}

update_nvim() {
    echo_step 'Updating nvim stuff...'

    nvim --headless "+Lazy! sync" +qa
    nvim /tmp/tmp.py +UpdateRemotePlugins
}

update_tmux_plugins() {
    echo_step 'Updating tmux plugins...'
    /usr/share/tmux-plugin-manager/bin/update_plugins all
}

update_nvm() {
    echo_step 'Updating nvm...'
    nvm upgrade
}

update_yarn_packages() {
    echo_step 'Updating yarn packages...'
    yarn global upgrade
}

update_go_binaries() {
    echo_step 'Updating go binaries...'
    "$GOPATH/bin/gup" update
}

update_antigen() {
    echo_step 'Updating antigen...'
    antigen update
}

prune_disk() {
    echo_step 'Pruning disk...'
    bash "$path_dotfiles/maintenance/prune_disk.sh"
}

ssh_agent
update_submodules
update_arch_packages
remove_orphan_arch_packages
update_nvim
update_tmux_plugins
update_nvm
update_yarn_packages
update_go_binaries
update_antigen
prune_disk
success
