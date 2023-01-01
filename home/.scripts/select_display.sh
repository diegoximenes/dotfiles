#!/bin/bash

CONFIG_FILE_PATH="$HOME/.config/dotfiles/config.json"

prepare_config_file() {
    mkdir -p "${CONFIG_FILE_PATH%/*}"

    local invalid
    invalid=false

    local config
    # strip empty char
    config=$(xargs < "$CONFIG_FILE_PATH")

    if ! jq -e . > /dev/null 2>&1 <<< "$config"; then
        # invalid json
        invalid=true
    fi
    if [[ "$config" == "" ]]; then
        # empty string
        invalid=true
    fi

    if $invalid; then
        echo "{}" > "$CONFIG_FILE_PATH"
    fi
}

disconnected="$(xrandr -q | grep 'disconnected' | awk '{print $1}')"
connected="$(xrandr -q | grep ' connected' | awk '{print $1}')"

################################################################################

restart_dunst_i3() {
    source "$HOME/.scripts/generate_configs_dependent_on_screen.sh"

    # restart dunst to ensure proper location on screen
    pgrep -x dunst >/dev/null && killall dunst
    setsid dunst 2>/dev/null &

    # restart i3 to ensure polybar's proper location
    i3-msg restart
}

get_resolution() {
    local screen
    screen="$1"

    local res
    res="$(xrandr -q \
        | sed -n "/^$screen/,/\+/p" \
        | tail -n 1 \
        | awk '{print $1}')"

    local x_res
    x_res="$(echo "$res" | sed 's/x.*//')"
    local y_res
    y_res="$(echo "$res" | sed 's/.*x//')"

    echo "$x_res $y_res"
}

mirror_screen() {
    local primary
    primary="$1"

    local x_res_primary
    local y_res_primary
    read -r x_res_primary y_res_primary < <(get_resolution "$primary")

    local xrandr_cmd
    xrandr_cmd="xrandr --output $primary --auto --scale 1.0x1.0"
    for secondary in $connected; do
        if [[ "$secondary" != "$primary" ]]; then
            local x_res_secondary
            local y_res_secondary
            read -r x_res_secondary y_res_secondary < <(get_resolution "$secondary")

            local scale_x
            scale_x=$(echo "$x_res_primary / $x_res_secondary" | bc -l)
            local scale_y
            scale_y=$(echo "$y_res_primary / $y_res_secondary" | bc -l)

            xrandr_cmd="$xrandr_cmd --output $secondary --auto --same-as $primary --scale ${scale_x}x${scale_y}"
        fi
    done
    eval "$xrandr_cmd"

    jq '. + {"screen": {"mode": "mirror", "primary": "'"$primary"'"}}' "$CONFIG_FILE_PATH" | sponge "$CONFIG_FILE_PATH"
}

split_screen() {
    local primary
    primary="$1"
    direction="$(printf "left-of\nright-of\nabove\nbelow" \
        | rofi -dmenu -i -p "which side of $primary should $secondary be on?")"
    xrandr --output "$primary" --auto --scale 1.0x1.0 \
        --output "$secondary" --"$direction" "$primary" --auto --scale 1.0x1.0

    jq '. + {"screen": {"mode": "split", "primary": "'"$primary"'"}}' "$CONFIG_FILE_PATH" | sponge "$CONFIG_FILE_PATH"
}

select_screen() {
    local selected
    selected="$1"

    local xrandr_cmd
    xrandr_cmd="xrandr --output $selected --auto --scale 1.0x1.0"
    local screens
    screens="$connected $disconnected"
    for screen in $screens; do
        if [[ "$screen" != "$selected" ]]; then
            xrandr_cmd="$xrandr_cmd --output $screen --off"
        fi
    done
    eval "$xrandr_cmd"

    jq '. + {"screen": {"mode": "single", "primary": "'"$selected"'"}}' "$CONFIG_FILE_PATH" | sponge "$CONFIG_FILE_PATH"
}

select_primary() {
    echo "$connected" | rofi -dmenu -i -no-custom -p  "which one is the primary?"
}

exit_case_empty() {
    local param
    param="$1"
    [[ "$param" == "" ]] && exit
}

mirror_config() {
    local primary
    primary="$(select_primary)"
    exit_case_empty "$primary"
    mirror_screen "$primary"
}

split_config() {
    local cnt_connected
    cnt_connected=$(echo "$connected" | wc -l)
    if [[ "$cnt_connected" -gt '2' ]]; then
        notify-send 'Unable to handle more than 2 screens, please configure it manually.' -u 'critical'
    else
        local primary
        primary="$(select_primary)"
        local secondary
        secondary="$(echo "$connected" | grep -v -w "$primary")"
        exit_case_empty "$primary"
        split_screen "$primary" "$secondary"
    fi
}

mirror_largest_screen() {
    # get largest screen
    local largest_screen
    largest_screen=""
    local largest_size
    largest_size=0
    for screen in $connected; do
        local x_res
        local y_res
        read -r x_res y_res < <(get_resolution "$screen")

        local size
        size="$(("$x_res" * "$y_res"))"
        if [[ "$size" -gt "$largest_size" ]]; then
            largest_size=$size
            largest_screen=$screen
        fi
    done

    mirror_screen "$largest_screen"
    restart_dunst_i3
}

user_config() {
    local cnt_connected
    cnt_connected=$(echo "$connected" | wc -l)

    if [[ "$cnt_connected" -eq "1" ]]; then
        select_screen "$connected"
    else
        local opt
        opt="$(printf '%s\ndefault\nmirror\nsplit' "$connected" \
            | rofi -dmenu -i -no-custom -p 'which screen arrangement?')"
        case "$opt" in
            'default') default_config ;;
            'mirror') mirror_config ;;
            'split') split_config ;;
            '') exit ;;
            *) select_screen "$opt" ;;
        esac
    fi

    restart_dunst_i3
}

default_config() {
    local cnt_connected
    cnt_connected=$(echo "$connected" | wc -l)

    if [[ "$cnt_connected" -eq "1" ]]; then
        select_screen "$connected"
        restart_dunst_i3
    else
        mirror_largest_screen
    fi
}

prepare_config_file

case "$1" in
    --default_config)
        default_config
        ;;
    *) user_config ;;
esac
