#!/bin/bash

path_current_file="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
path_dotfiles="$path_current_file/.."

source "$path_dotfiles/common.sh"

docker_prune() {
    echo_step 'Starting dockerd...'
    sudo -b dockerd &> /dev/null
    sleep 3

    echo_step 'Pruning docker...'
    docker system prune -f --filter "until=120h" # 5 days

    echo_step 'Pruning docker volumes...'
    docker volume prune -f

    sudo pkill dockerd
}

empty_trash() {
    echo_step 'Emptying trash...'
    trash-empty -f
}

go_clean() {
    echo_step 'Cleaning go cache...'
    go clean -cache -modcache
}

docker_prune
go_clean
empty_trash
success
