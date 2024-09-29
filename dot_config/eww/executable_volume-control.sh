#!/bin/bash

function get_volume {
    pactl get-sink-volume @DEFAULT_SINK@ | grep Volume | awk '{print $5}' | tr -d '%'
}

function is_muted {
    pactl get-sink-mute @DEFAULT_SINK@ | grep -q "yes"
}

function volume_up {
    current_volume=$(get_volume)
    if [ "$current_volume" -lt 100 ]; then
        pactl set-sink-volume @DEFAULT_SINK@ +5%
    fi
}

function volume_down {
    pactl set-sink-volume @DEFAULT_SINK@ -5%
}

function toggle_mute {
    pactl set-sink-mute @DEFAULT_SINK@ toggle
}

case $1 in
    up)
        volume_up
        ;;
    down)
        volume_down
        ;;
    toggle)
        toggle_mute
        ;;
esac

# Update Eww widgets
eww update volume="$(sh ./get-volume.sh)"
