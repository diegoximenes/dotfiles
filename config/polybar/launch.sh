#!/usr/bin/env bash

CONFIG_FILE_PATH="$HOME/.config/dotfiles/config.json"

kill_polybars() {
    killall -q polybar
}

wait_polybars_shutdown() {
    while pgrep -u $UID -x polybar >/dev/null; do
        sleep 1;
    done
}

start_polybars_split_screen_mode() {
    local primary_screen
    primary_screen=$(jq '.screen.primary' "$CONFIG_FILE_PATH" 2> /dev/null)

    local screen
    for screen in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        local tray_position
        if [[ "\"$screen\"" == "$primary_screen" ]]; then
            tray_position="left"
        else
            tray_position="none"
        fi

        SCREEN="$screen" TRAY_POSITION="$tray_position" polybar bottom -c ~/.config/polybar/config &
    done
}

start_polybar_default_screen_mode() {
    TRAY_POSITION="left" polybar bottom -c ~/.config/polybar/config &
}

start_polybars() {
    local screen_mode
    screen_mode=$(jq '.screen.mode' "$CONFIG_FILE_PATH" 2> /dev/null)
    echo "screen_mode=$screen_mode"
    case "$screen_mode" in
        "\"split\"") start_polybars_split_screen_mode ;;
        *) start_polybar_default_screen_mode ;;
    esac
}

kill_polybars
wait_polybars_shutdown
start_polybars
