#!/bin/bash

source "/Users/diego/dotfiles/common.sh"

ssh_agent() {
    eval "$(ssh-agent)"
    ssh-add
}

update_submodules() {
    echo_step 'Updating submodules...'
    git submodule update --remote --merge
}

update_nvim() {
    echo_step 'Updating nvim stuff...'

    nvim --headless "+Lazy! sync" +qa
    nvim --headless "+TSUpdateSync" +qa
    nvim /tmp/tmp.py +UpdateRemotePlugins
}

update_tmux_plugins() {
    echo_step 'Updating tmux plugins...'
    ~/.tmux/plugins/tpm/bin/update_plugins all
}

update_yarn_packages() {
    echo_step 'Updating yarn packages...'
    yarn global upgrade
}

update_go_binaries() {
    echo_step 'Updating go binaries...'
    "$GOPATH/bin/gup" update
}

update_zsh() {
    zsh "/Users/diego/dotfiles/maintenance/update_zsh.sh"
}

update_github() {
    echo_step 'Updating GitHub CLI...'
    gh extension upgrade --all
}

update_brew() {
    echo_step 'Updating Homebrew...'
    brew update
    brew upgrade
    brew upgrade --cask
}

ssh_agent
update_submodules
update_brew
update_zsh
update_nvim
update_tmux_plugins
update_yarn_packages
update_go_binaries
update_github
success
