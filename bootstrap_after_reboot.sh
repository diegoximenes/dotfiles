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

set_cron() {
    echo_step 'Setting cron...'
    sudo systemctl enable cronie.service
    sudo systemctl start cronie.service
    crontab crontab.txt
}

update_dotfiles() {
    echo_step 'Updating dotfiles...'
    bash ~/Documents/dotfiles/update.sh
}

set_cron
update_dotfiles
success
