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

device_paired() {
    device_info=$(bluetoothctl info "$1")
    if echo "$device_info" | grep -q "Paired: yes"; then
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

get_delimiter() {
    local count=$1
    if [[ $count -gt 0 ]]; then
        echo ", "
    else
        echo ""
    fi
}

print_info() {
    bluetoothctl | while read -r; do
        local out
        out=""

        if power_on; then
            out="$out${BLUE} ${NC}"

            local count_connected_devices=0
            local count_paired_devices=0
            local devices
            mapfile -t devices < <(bluetoothctl devices | cut -d ' ' -f 2)
            for i in "${!devices[@]}"; do
                if device_paired "${devices[$i]}"; then
                    count_paired_devices=$((count_paired_devices+1))
                fi

                if device_connected "${devices[$i]}"; then
                    local device_alias
                    device_alias=$(bluetoothctl info "${devices[$i]}" | \
                        grep "Alias" | \
                        cut -d ' ' -f 2-
                    )

                    local delimiter
                    delimiter=$(get_delimiter $count_connected_devices)
                    out="$out$delimiter${device_alias}"

                    count_connected_devices=$((count_connected_devices+1))
                fi
            done

            if [[ $count_paired_devices -gt 0 ]]; then
                local delimiter
                delimiter=$(get_delimiter $count_connected_devices)

                local paired="P:$count_paired_devices"

                out="$out$delimiter$paired"
            fi
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
