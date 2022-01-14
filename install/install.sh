#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

DOTFILES_PATH="$HOME/Documents/dotfiles"

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

clone_git_repo() {
    echo_step 'Cloning git repo...'
    mkdir -p "$DOTFILES_PATH"
    git clone --recurse-submodules https://github.com/diegoximenes/dotfiles.git "$DOTFILES_PATH"
    cd "$DOTFILES_PATH"
    git remote set-url origin git@github.com:diegoximenes/dotfiles.git
}

bootstrap() {
    echo_step 'Bootstraping...'
    bash "$DOTFILES_PATH/install/bootstrap.sh" --install
}

clone_git_repo
bootstrap
success
