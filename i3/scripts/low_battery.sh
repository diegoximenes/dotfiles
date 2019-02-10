#!/bin/bash

CAPACITY_THRESHOLD=10
[[ "$(cat /sys/class/power_supply/BAT0/status)" == "Charging" ]] && exit
if [[ "$(cat /sys/class/power_supply/BAT0/capacity)" -lt $CAPACITY_THRESHOLD ]]; then
    export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus && notify-send -u critical "Battery too low."
fi
