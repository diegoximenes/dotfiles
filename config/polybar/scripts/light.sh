#!/bin/bash

info() {
    local l
    l=$(xbacklight)
    l=${l%.*}
    echo "🔆 ${l}%"
}

inc() {
    xbacklight -inc 2
}

dec() {
    xbacklight -dec 2
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
