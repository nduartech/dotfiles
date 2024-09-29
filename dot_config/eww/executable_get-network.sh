#!/bin/bash

# Function to check if a network interface is up and has an IP address
is_interface_up_and_connected() {
    ip addr show $1 | grep -q "inet "
}

# Check Ethernet (use your specific interface name)
if is_interface_up_and_connected enp4s0; then
    echo "󰈀 "   # Ethernet icon
    exit 0
fi

# Check Wi-Fi
if is_interface_up_and_connected wlan0; then
    # Get Wi-Fi signal strength
    signal=$(iwconfig wlan0 | grep "Link Quality" | awk '{print $2}' | cut -d'=' -f2 | cut -d'/' -f1)
    max_signal=$(iwconfig wlan0 | grep "Link Quality" | awk '{print $2}' | cut -d'=' -f2 | cut -d'/' -f2)
    
    if [ -n "$signal" ] && [ -n "$max_signal" ]; then
        strength=$((signal * 100 / max_signal))
        
        if [ $strength -ge 80 ]; then
            echo "󰤨 "  # Strong Wi-Fi signal
        elif [ $strength -ge 60 ]; then
            echo "󰤥 "  # Medium-strong Wi-Fi signal
        elif [ $strength -ge 40 ]; then
            echo "󰤢 "  # Medium Wi-Fi signal
        elif [ $strength -ge 20 ]; then
            echo "󰤟 "  # Weak Wi-Fi signal
        else
            echo "󰤯 "  # Very weak Wi-Fi signal
        fi
    else
        echo "󰤨 "  # Default to strong if we can't determine strength
    fi
    exit 0
fi

# If no connection is detected
echo "󰤭 "  # Disconnected icon
