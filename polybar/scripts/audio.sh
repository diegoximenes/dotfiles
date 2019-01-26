#!/bin/bash

volume_sink_up() {
    pactl set-sink-volume @DEFAULT_SINK@ +3%
}

volume_sink_down() {
    pactl set-sink-volume @DEFAULT_SINK@ -3%
}

mute_sink() {
    pactl set-sink-mute @DEFAULT_SINK@ toggle
}

volume_source_up() {
    pactl set-source-volume @DEFAULT_SOURCE@ +3%
}

volume_source_down() {
    pactl set-source-volume @DEFAULT_SOURCE@ -3%
}

mute_source() {
    pactl set-source-mute @DEFAULT_SOURCE@ toggle
}

sink_volume() {
    list_sinks=$(pacmd list-sinks)
    default_sink=$(pacmd stat | awk -F ": " '/^Default sink name: / { print $2 }')
    active_port=$(echo "$list_sinks" | awk '
        /name: / { is_default = ($2 == "<'"$default_sink"'>") }
        /active port: / { if (is_default) active_port = $3 }
        END { print substr(active_port, 2, length(active_port) - 2) }')
    out=$(echo "$list_sinks" | awk '
        /name: / { is_default = ($2 == "<'"$default_sink"'>") }
        /muted: / { if (is_default) muted = $2 }
        /volume: front-left:/ { if (is_default) volume = $5 }
        /'"$active_port"': / { if (is_default) port = $2 }
        END { if (muted == "no") printf "🔉 %s %s", volume, port; else printf "🔉 🗶 %s", port }')
    echo "$out"
}

source_volume() {
    list_sources=$(pacmd list-sources)
    default_source=$(pacmd stat | awk -F ": " '/^Default source name: / { print $2 }')
    active_port=$(echo "$list_sources" | awk '
        /name: / { is_default = ($2 == "<'"$default_source"'>") }
        /active port: / { if (is_default) active_port = $3 }
        END { print substr(active_port, 2, length(active_port) - 2) }')
    out=$(echo "$list_sources" | awk '
        /name: / { is_default = ($2 == "<'"$default_source"'>") }
        /muted: / { if (is_default) muted = $2 }
        /volume: front-left:/ { if (is_default) volume = $5 }
        /'"$active_port"': / { if (is_default) port = $2 }
        END { if (muted == "no") printf "🔬 %s %s", volume, port; else printf "🔬 🗶 %s", port }')
    echo "$out"
}

sink_volume_listener() {
    pactl subscribe | while read -r event; do
        match=$(echo "$event" | grep "'change' on sink")
        if [ "$match" != "" ]; then
            sink_volume
        fi
    done
}

source_volume_listener() {
    pactl subscribe | while read -r event; do
        match=$(echo "$event" | grep "'change' on source")
        if [ "$match" != "" ]; then
            source_volume
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
        sink_volume
    ;;
    --source_volume)
        source_volume
    ;;
    --sink_volume_listener)
        sink_volume
        sink_volume_listener
    ;;
    --source_volume_listener)
        source_volume
        source_volume_listener
    ;;
    *)
        echo "Wrong argument"
    ;;
esac
