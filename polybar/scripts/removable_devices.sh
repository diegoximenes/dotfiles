#!/bin/bash

devices="$(lsblk -Jplno NAME,TYPE,RM,SIZE,MOUNTPOINT,VENDOR)"
printed=false

print_removable_parts() {
    local removable_parts
    removable_parts="$1"
    local part_tag
    part_tag="$2"

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

            if [[ "$printed" == true ]]; then
                printf ', '
            fi
            printf "%s: %s (%s)" "$part_tag" "$vendor" "$size"
            printed=true
        done < <(echo "$removable_parts")
    fi
}

main() {
    local unmounted_removable_parts
    unmounted_removable_parts="$(echo "$devices" \
        | jq -r '.blockdevices[] | select(.type == "part") | select(.rm == "1") | select(.mountpoint == null) | "\(.name) \(.size)"')"
    local mounted_removable_parts
    mounted_removable_parts="$(echo "$devices" \
        | jq -r '.blockdevices[] | select(.type == "part") | select(.rm == "1") | select(.mountpoint != null) | "\(.name) \(.size)"')"

    print_removable_parts "$unmounted_removable_parts" 'U'
    print_removable_parts "$mounted_removable_parts" 'M'

    if [[ "$printed" == false ]]; then
        echo ""
    fi
}

main
