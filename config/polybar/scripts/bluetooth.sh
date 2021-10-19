#!/bin/bash

readonly BLUE="%{F#0e91f4}"
readonly NC="%{F-}"

power_on() {
    if bluetoothctl show | grep -q "Powered: yes"; then
        return 0
    else
        return 1
    fi
}

device_connected() {
    device_info=$(bluetoothctl info "$1")
    if echo "$device_info" | grep -q "Connected: yes"; then
        return 0
    else
        return 1
    fi
}

power_toggle() {
    if power_on; then
        bluetoothctl power off
    else
        bluetoothctl power on
    fi
}

print_info() {
    bluetoothctl | while read -r; do
        local out
        out=""

        if power_on; then
            out="$out${BLUE}${NC}"

            local paired_devices
            mapfile -t paired_devices < <(bluetoothctl paired-devices | cut -d ' ' -f 2)
            for i in "${!paired_devices[@]}"; do
                local device_alias
                device_alias=$(bluetoothctl info "${paired_devices[$i]}" | \
                    grep "Alias" | \
                    cut -d ' ' -f 2-
                )

                local devices_delimiter
                devices_delimiter=" "
                if [[ $i -gt 0 ]]; then
                    devices_delimiter=", "
                fi

                if device_connected "${paired_devices[$i]}"; then
                    local battery
                    battery=$(bluetooth-headset-battery-level "${paired_devices[$i]}")
                    battery=${battery##* }

                    out="$out$devices_delimiter${BLUE}$device_alias ($battery)${NC}"
                else
                    out="$out$devices_delimiter$device_alias"
                fi
            done
        else
            out="$out"
        fi
        echo "$out"
    done
}

case "$1" in
    --print_info)
        print_info
    ;;
    --power_toggle)
        power_toggle
    ;;
esac
