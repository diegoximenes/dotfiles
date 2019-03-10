#!/bin/bash

MAX_OUT_LEN=20

devices="$(lsblk -Jplno NAME,TYPE,RM,SIZE,MOUNTPOINT,VENDOR)"

format_removable_parts() {
    local removable_parts
    removable_parts="$1"

    local out
    out=''
    local first_device
    first_device=true
    if [[ -n "$removable_parts" ]]; then
        while read -r line; do
            local name
            name="$(echo "$line" | awk '{print $1}')"
            local size
            size="$(echo "$line" | awk '{print $2}')"
            local root
            root="$(echo "$name" | tr -d '[:digit:]')"
            local vendor
            vendor="$(echo "$devices" \
                | jq -r '.blockdevices[]  | select(.name == "'"$root"'") | .vendor' \
                | tr -d '[:space:]')"

            if [[ "$first_device" == false ]]; then
                out="$out, "
            fi
            out="$out$vendor ($size)"
            first_device=false
        done < <(echo "$removable_parts")
    fi
    echo "$out"
}

cnt_devices() {
    local removable_parts
    removable_parts="$1"

    local cnt
    if [[ "$removable_parts" != "" ]]; then
        cnt="$(echo "$removable_parts" | wc -l)"
    else
        cnt=0
    fi
    echo "$cnt"
}

main() {
    local unmounted_removable_parts
    unmounted_removable_parts="$(echo "$devices" \
        | jq -r '.blockdevices[] | select(.type == "part") | select(.rm == true) | select(.mountpoint == null) | "\(.name) \(.size)"')"
    local mounted_removable_parts
    mounted_removable_parts="$(echo "$devices" \
        | jq -r '.blockdevices[] | select(.type == "part") | select(.rm == true) | select(.mountpoint != null) | "\(.name) \(.size)"')"

    local unmounted_formated
    unmounted_formated="$(format_removable_parts "$unmounted_removable_parts")"
    local mounted_formated
    mounted_formated="$(format_removable_parts "$mounted_removable_parts")"

    local cnt_unmounted
    cnt_unmounted="$(cnt_devices "$unmounted_removable_parts")"
    local cnt_mounted
    cnt_mounted="$(cnt_devices "$mounted_removable_parts")"

    local out_full
    out_full=''
    local out_short
    out_short=''
    if [[ "$cnt_unmounted" -gt 0 ]]; then
        out_full="U: $unmounted_formated"
        out_short="U: $cnt_unmounted"
    fi
    if [[ "$cnt_mounted" -gt 0 ]]; then
        if [[ "$out_full" != "" ]]; then
            out_full="$out_full,"
            out_short="$out_short,"
        fi
        out_full="$out_full M: $mounted_formated"
        out_short="$out_short M: $cnt_mounted"
    fi

    if [[ "$out_full" == "" ]]; then
        echo ""
    elif [[ "${#out_full}" -gt $MAX_OUT_LEN ]]; then
        echo "💾 $out_short"
    else
        echo "💾 $out_full"
    fi
}

main
