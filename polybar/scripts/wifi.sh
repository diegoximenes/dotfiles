#!/bin/bash

wifi=$(nmcli -g IN-USE,SSID,SIGNAL dev wifi | grep "^\*")
if [[ $wifi =~ ^\*:(.+):(.+)$ ]]; then
    ssid="${BASH_REMATCH[1]}"
    signal="${BASH_REMATCH[2]}"
    echo " $ssid $signal%"
else
    echo " down"
fi
