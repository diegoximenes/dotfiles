#!/bin/bash

CONFIG_FILE_PATH="$HOME/.config/dotfiles/config.json"

source_env_vars() {
    local use_default_config
    use_default_config=$1

    local primary_screen
    primary_screen=$(jq '.screen.primary' "$CONFIG_FILE_PATH" 2> /dev/null)

    if [[ $use_default_config == true ]] || [[ "$primary_screen" == "\"eDP1\"" ]]; then
        source "$HOME/.scripts/env_vars/edp.sh"
    elif [[ "$primary_screen" =~ ^\"HDMI* ]]; then
        source "$HOME/.scripts/env_vars/hdmi.sh"
    else
        notify-send -u critical "Didn't find env vars for screen $primary_screen. Falling back to edp env vars."
        source "$HOME/.scripts/env_vars/edp.sh"
    fi
}

envsubst_tpl() {
    envsubst < "$HOME/.config/dunst/dunstrc.tpl" > "$HOME/.config/dunst/dunstrc"
    envsubst < "$HOME/.config/termite/config.tpl" > "$HOME/.config/termite/config"
    envsubst < "$HOME/.mozilla/firefox/profiles/diego/user.js.tpl" > "$HOME/.mozilla/firefox/profiles/diego/user.js"
    envsubst '$I3_FONT_SIZE $I3_GOOGLE_CHROME_SCALE_FACTOR $I3_SCRATCHPAD_TERMINAL_SIZE $I3_SCRATCHPAD_MAXIMUM_FLOATING_SIZE' < "$HOME/.config/i3/config.tpl" > "$HOME/.config/i3/config"
    envsubst '$POLYBAR_BAR_HEIGHT $POLYBAR_BAR_TRAY_MAXSIZE $POLYBAR_FONT_0_SIZE $POLYBAR_FONT_1_SCALE $POLYBAR_FONT_2_SIZE $POLYBAR_FONT_3_SIZE' < "$HOME/.config/polybar/config.tpl" > "$HOME/.config/polybar/config"
}

case "$1" in
    --default_config)
        source_env_vars true
        ;;
    *)
        source_env_vars false
        ;;
esac

envsubst_tpl
