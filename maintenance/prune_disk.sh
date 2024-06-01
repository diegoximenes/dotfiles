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
