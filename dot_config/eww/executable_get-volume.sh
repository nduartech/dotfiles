#!/bin/bash

volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep Volume | awk '{print $5}' | tr -d '%')
mute_status=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

if [ "$mute_status" = "yes" ]; then
    echo "󰝟 "  # Muted icon
elif [ "$volume" -ge 70 ]; then
    echo "󰕾 "  # High volume icon
elif [ "$volume" -ge 30 ]; then
    echo "󰖀 "  # Medium volume icon
else
    echo "󰕿 "  # Low volume icon
fi
