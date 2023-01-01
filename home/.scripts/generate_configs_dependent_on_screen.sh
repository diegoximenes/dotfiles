#!/bin/bash

CONFIG_FILE_PATH="$HOME/.config/dotfiles/config.json"

source_env_vars() {
    local primary_screen
    primary_screen=$(jq '.screen.primary' "$CONFIG_FILE_PATH" 2> /dev/null)

    if [[ "$primary_screen" == "\"eDP1\"" ]]; then
        source "$HOME/.scripts/env_vars/edp.sh"
    elif [[ "$primary_screen" == "\"HDMI1\"" ]]; then
        source "$HOME/.scripts/env_vars/hdmi.sh"
    else
        notify-send -u critical "Didn't find env vars for screen $primary_screen. Falling back to edp env vars."
        source "$HOME/.scripts/env_vars/edp.sh"
    fi
}

envsubst_tpl() {
    envsubst < "$HOME/.config/dunst/dunstrc.tpl" > "$HOME/.config/dunst/dunstrc"
    envsubst < "$HOME/.config/termite/config.tpl" > "$HOME/.config/termite/config"
}

source_env_vars
envsubst_tpl
