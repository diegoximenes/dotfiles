#!/bin/bash

info() {
    local info
    info="$(brightnessctl -m)"
    # split comma separated string into array
    local info_array
    IFS=',' read -r -a info_array <<< "$info"
    echo "🔆 ${info_array[3]}"
}

inc() {
    brightnessctl set +1%
}

dec() {
    brightnessctl set 1%-
}

case "$1" in
    --info)
        info
    ;;
    --inc)
        inc
    ;;
    --dec)
        dec
    ;;
esac
