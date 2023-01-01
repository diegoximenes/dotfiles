#!/usr/bin/env bash

CONFIG_FILE_PATH="$HOME/.config/dotfiles/config.json"

kill_polybars() {
    # always SIGKILL, SIGTERM fails frequently.

    # wait before killing polybar scripts, since polybar could spawn those
    # scripts again after they are killed
    killall polybar --quiet --wait --exact --signal SIGKILL

    local pgrps_to_kill
    pgrps_to_kill="$(ps -e -o pgrp,cmd \
        | grep '\(/bin/bash\|python3\) .*/\.config/polybar/scripts' \
        | awk '{print $1}' \
        | sort \
        | uniq
    )"
    for pgrp in ${pgrps_to_kill}; do
        kill -SIGKILL "-$pgrp"
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
    case "$screen_mode" in
        "\"split\"") start_polybars_split_screen_mode ;;
        *) start_polybar_default_screen_mode ;;
    esac

    # workaround to avoid polybar tray not showing up
    sleep 1
    local i3_current_workspace
    i3_current_workspace=$(i3-msg -t get_workspaces \
        | jq '.[] | select(.focused==true).name' \
        | cut -d"\"" -f2 \
    )
    i3-msg workspace 0
    i3-msg workspace "$i3_current_workspace"
}

kill_polybars
start_polybars
notify-send -u low "polybar started."
