#!/bin/bash

MAX_VOLUME=153
DELTA_VOLUME=3

volume_sink_up() {
    local volume
    volume="$(get_sink_info | awk '{print $2}' | tr -d '%')"
    if (( volume + DELTA_VOLUME <= MAX_VOLUME )); then
        pactl set-sink-volume @DEFAULT_SINK@ "+$DELTA_VOLUME%"
    fi
    pactl set-sink-mute @DEFAULT_SINK@ 0
}

volume_sink_down() {
    pactl set-sink-volume @DEFAULT_SINK@ "-$DELTA_VOLUME%"
}

mute_sink() {
    pactl set-sink-mute @DEFAULT_SINK@ toggle
}

volume_source_up() {
    local volume
    volume="$(get_source_info | awk '{print $2}' | tr -d '%')"
    if (( volume + DELTA_VOLUME <= MAX_VOLUME )); then
        pactl set-source-volume @DEFAULT_SOURCE@ "+$DELTA_VOLUME%"
    fi
    pactl set-source-mute @DEFAULT_SOURCE@ 0
}

volume_source_down() {
    pactl set-source-volume @DEFAULT_SOURCE@ "-$DELTA_VOLUME%"
}

mute_source() {
    pactl set-source-mute @DEFAULT_SOURCE@ toggle
}

get_info() {
    local devices
    devices="$1"
    local default_device
    default_device="$2"

    local active_port
    active_port=$(echo "$devices" | awk '
        /name: / { is_default = ($2 == "<'"$default_device"'>") }
        /active port: / { if (is_default) active_port = $3 }
        END { print substr(active_port, 2, length(active_port) - 2) }')

    local default_device_info
    default_device_info=$(echo "$devices" | awk '
         /name: / { is_default = ($2 == "<'"$default_device"'>") }
         /muted: / { if (is_default) muted = $2 }
         /volume: front-left:/ { if (is_default) volume = $5 }
         /'"$active_port"': / { if (is_default) port = $2 }
         END { if (muted == "no") printf "unmuted %s %s", volume, port; else printf "muted %s %s", volume, port }')
    echo "$default_device_info"
}

print_info() {
    local info
    info="$1"
    local device_tag
    device_tag="$2"

    local mute_state
    mute_state="$(echo "$info" | awk '{print $1}')"
    local volume
    volume="$(echo "$info" | awk '{print $2}')"
    local port
    port="$(echo "$info" | awk '{print $3}')"

    if [[ "$mute_state" == "muted" ]]; then
        echo "$device_tag 🗶 $port"
    else
        echo "$device_tag $volume $port"
    fi
}

get_sink_info() {
    local sinks
    sinks=$(pacmd list-sinks)

    local default_sink
    default_sink=$(pacmd stat | awk -F ": " '/^Default sink name: / { print $2 }')

    get_info "$sinks" "$default_sink"
}

print_sink_info() {
    print_info "$(get_sink_info)" '🔉'
}

get_source_info() {
    local sources
    sources=$(pacmd list-sources)

    local default_source
    default_source=$(pacmd stat | awk -F ": " '/^Default source name: / { print $2 }')

    get_info "$sources" "$default_source"
}

print_source_info() {
    print_info "$(get_source_info)" '🔬'
}

sink_volume_listener() {
    pactl subscribe | while read -r event; do
        match=$(echo "$event" | grep "'change' on sink")
        if [ "$match" != "" ]; then
            print_sink_info
        fi
    done
}

source_volume_listener() {
    pactl subscribe | while read -r event; do
        match=$(echo "$event" | grep "'change' on source")
        if [ "$match" != "" ]; then
            print_source_info
        fi
    done
}

case "$1" in
    --mute_sink)
        mute_sink
    ;;
    --mute_source)
        mute_source
    ;;
    --volume_sink_up)
        volume_sink_up
    ;;
    --volume_sink_down)
        volume_sink_down
    ;;
    --volume_source_up)
        volume_source_up
    ;;
    --volume_source_down)
        volume_source_down
    ;;
    --sink_volume)
        print_sink_info
    ;;
    --source_volume)
        print_source_info
    ;;
    --sink_volume_listener)
        print_sink_info
        sink_volume_listener
    ;;
    --source_volume_listener)
        print_source_info
        source_volume_listener
    ;;
    *)
        echo "Wrong argument"
    ;;
esac
