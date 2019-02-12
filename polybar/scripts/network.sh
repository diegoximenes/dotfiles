#!/bin/bash

default_route="$(route | awk '/^default/ {print $8}')"
if [[ "$default_route" =~ ^en(.+)$ ]]; then
    # ethernet
    echo " $default_route"
else
    # wlan or wwan
    wifi=$(nmcli -g IN-USE,SSID dev wifi | grep "^\*")
    if [[ "$wifi" =~ ^\*:(.+)$ ]]; then
        ssid="${BASH_REMATCH[1]}"
        echo " $ssid"
    else
        echo " down"
    fi
fi
echo "default_route=$default_route"
