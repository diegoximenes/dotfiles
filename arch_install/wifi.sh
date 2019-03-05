#!/bin/bash

if [[ ! $# -eq 2 ]]; then
    echo "usage: bash wifi.sh SSID PASSWORD"
    exit
fi

ssid="$1"
password="$2"

INTERFACE='wlp3s0'

ip link set "$INTERFACE" up
wpa_supplicant -B -i "$INTERFACE" -c <(wpa_passphrase "$ssid" "$password")
systemctl start dhcpcd@"$INTERFACE".service
