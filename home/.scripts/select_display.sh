#!/bin/bash

get_resolution() {
    local screen
    screen="$1"

    xrandr -q \
        | sed -n "/^$screen/,/\+/p" \
        | tail -n 1 \
        | awk '{print $1}'
}

get_x_resolution() {
    local res
    res="$1"
    echo "$res" | sed 's/x.*//'
}

get_y_resolution() {
    local res
    res="$1"
    echo "$res" | sed 's/.*x//'
}

mirror_screen() {
    local primary
    primary="$1"
    local secondary
    secondary="$2"

    local res_primary
    res_primary="$(get_resolution "$primary")"

    local res_secondary
    res_secondary="$(get_resolution "$secondary")"

    local x_res_primary
    x_res_primary="$(get_x_resolution "$res_primary")"
    local y_res_primary
    y_res_primary="$(get_y_resolution "$res_primary")"
    local x_res_secondary
    x_res_secondary="$(get_x_resolution "$res_secondary")"
    local y_res_secondary
    y_res_secondary="$(get_y_resolution "$res_secondary")"

    local scale_x
    scale_x=$(echo "$x_res_primary / $x_res_secondary" | bc -l)
    local scale_y
    scale_y=$(echo "$y_res_primary / $y_res_secondary" | bc -l)

    xrandr --output "$primary" --auto --scale 1.0x1.0 \
        --output "$secondary" --auto --same-as "$primary" \
        --scale "$scale_x"x"$scale_y"
}

function split_screen() {
    direction="$(printf "left-of\nright-of\nabove\nbelow" | dmenu -i -p "which side of $primary should $secondary be on?")"
    xrandr --output "$primary" --auto --scale 1.0x1.0 --output "$secondary" --"$direction" "$primary" --auto --scale 1.0x1.0
}

two_screens() {
    local connected
    connected="$1"

    local primary
    primary=$(echo "$connected" | dmenu -i -p "which one is the primary?")
    local secondary
    secondary=$(echo "$connected" | grep -v "$primary")

    local mirror
    mirror=$(printf "yes\nno" | dmenu -i -p "mirror?")
    case "$mirror" in
        yes) mirror_screen "$primary" "$secondary" ;;
        no) split_screen "$primary" "$secondary" ;;
    esac
}

multi_screen() {
    local screens
    screens="$1"
    local connected
    connected="$2"

    case "$(echo "$connected" | wc -l)" in
        2) two_screens "$connected" ;;
        *) notify-send -u normal 'Too much screens, configure it manually.' ;;
    esac
}

select_screen() {
    local screens
    screens="$1"
    local selected
    selected="$2"

    xrandr --output "$selected" --auto --scale 1.0x1.0 $(echo "$screens" | grep -v "$selected" | awk '{print "--output", $1, "--off"}' | tr '\n' ' ')
}

main() {
    local screens
    screens="$(xrandr -q | grep 'connected')"

    local connected
    connected="$(echo "$screens" | grep ' connected' | awk '{print $1}')"
    local cnt_connected
    cnt_connected=$(echo "$connected" | wc -l)

    if (( cnt_connected == 1 )); then
        select_screen "$screens" "$connected"
    else
        local opt
        opt="$(printf '%s\nmulti_screen\nmanual' "$connected" \
            | dmenu -i -p 'which screen arrangement?')"
        case "$opt" in
            'multi_screen') multi_screen "$screens" "$connected" ;;
            'manual') arandr & ;;
            *) select_screen "$screens" "$opt" ;;
        esac
    fi

    # restart dunst to ensure proper location on screen
    pgrep -x dunst >/dev/null && killall dunst
    setsid dunst 2>/dev/null &
}

main
