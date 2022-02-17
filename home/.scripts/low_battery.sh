#!/bin/bash

CAPACITY_THRESHOLD=20

battery_dir="/sys/class/power_supply/BAT0/"
if [[ -d "$battery_dir" ]]; then
    [[ "$(cat "$battery_dir"/status)" == "Charging" ]] && exit
    if [[ "$(cat "$battery_dir"/capacity)" -lt $CAPACITY_THRESHOLD ]]; then
        export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus && notify-send -u critical "Battery too low."
    fi
fi
