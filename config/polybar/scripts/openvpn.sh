#!/bin/bash

connection=$(pgrep -a openvpn$ | head -n 1 | awk '{print $NF }' | cut -d '.' -f 1)

if [[ -n "$connection" ]]; then
    echo "VPN"
else
    echo ""
fi
