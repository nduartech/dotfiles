#!/bin/bash

# Check if nvidia-smi is available
if ! command -v nvidia-smi &> /dev/null; then
    echo "󰢮 N/A"
    exit 0
fi

# Get GPU usage
gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | awk '{ print $1 }')

# Get VRAM usage
vram_used=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits | awk '{ print $1 }')
vram_total=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits | awk '{ print $1 }')
vram_usage=$((vram_used * 100 / vram_total))

# Output icon based on GPU usage
if [ $gpu_usage -ge 80 ]; then
    echo "󰢮 $gpu_usage% | 󰍛 $vram_usage% "  # High GPU usage icon
elif [ $gpu_usage -ge 50 ]; then
    echo "󰢮 $gpu_usage% | 󰍛 $vram_usage% "  # Medium GPU usage icon
else
    echo "󰢮 $gpu_usage% | 󰍛 $vram_usage% "  # Low GPU usage icon
fi
