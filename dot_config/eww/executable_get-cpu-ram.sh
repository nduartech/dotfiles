#!/bin/bash

# Get CPU usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
cpu_usage=${cpu_usage%.*}  # Remove decimal part

# Get RAM usage
ram_total=$(free -m | awk '/Mem:/ {print $2}')
ram_used=$(free -m | awk '/Mem:/ {print $3}')
ram_usage=$((ram_used * 100 / ram_total))

# Output icon based on CPU usage
if [ $cpu_usage -ge 80 ]; then
    echo "󰘚 $cpu_usage% | 󰍛 $ram_usage% "  # High CPU usage icon
elif [ $cpu_usage -ge 50 ]; then
    echo "󰘙 $cpu_usage% | 󰍛 $ram_usage% "  # Medium CPU usage icon
else
    echo "󰘚 $cpu_usage% | 󰍛 $ram_usage% "  # Low CPU usage icon
fi
