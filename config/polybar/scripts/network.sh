#!/bin/bash

default_route="$(ip route | awk '/^default/' | awk '{print $5}')"
if [[ "$default_route" =~ ^en(.+)$ ]]; then
    # ethernet
    echo "🖥 $default_route"
else
    # wlan or wwan
    wifi=$(nmcli -g IN-USE,SSID dev wifi | grep "^\*")
    if [[ "$wifi" =~ ^\*:(.+)$ ]]; then
        ssid="${BASH_REMATCH[1]}"
        echo "🛰 $ssid"
    else
        echo "🛰 down"
    fi
fi
