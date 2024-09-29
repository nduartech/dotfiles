#!/bin/bash

# Get the monitor number (0 or 1) from the script argument
monitor=$1

# Set the main workspace based on the monitor
if [ "$monitor" -eq 0 ]; then
    main_workspace=2
    monitor_name="HDMI-A-1"
else
    main_workspace=1
    monitor_name="DP-2"
fi

# Get the active workspace ID
active_workspace=$(hyprctl activeworkspace -j | jq -r '.id')

# Debug: Print active workspace
echo "DEBUG: Active workspace: $active_workspace" >&2

# Get workspace information
workspaces=$(hyprctl workspaces -j | jq -r --arg monitor "$monitor_name" --arg active "$active_workspace" '
  map(select(.name != "special:hdrop")) |
  map(select(.monitor == $monitor)) |
  map({id: .id, active: (.id | tostring == $active)}) |
  sort_by(.id)
')

# Process workspace information
main_active=$(echo "$workspaces" | jq -r ".[] | select(.id == $main_workspace and .active) | .id")
other_active=$(echo "$workspaces" | jq -r ".[] | select(.id != $main_workspace and .active) | .id")
main_exists=$(echo "$workspaces" | jq -r ".[] | select(.id == $main_workspace) | .id")

# Determine the output
if [ -n "$main_active" ]; then
    output="🐺"
elif [ -n "$other_active" ]; then
    output="• 🐺"
elif [ -n "$main_exists" ]; then
    output="•"
else
    output="-"
fi

# Debug: Print processed output
echo "DEBUG: Processed output: $output" >&2

# Return the processed output
echo "$output"
