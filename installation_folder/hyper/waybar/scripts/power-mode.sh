#!/bin/bash

GOV_FILE="/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"
POWER_SUPPLY=$(ls /sys/class/power_supply | grep -E 'AC|ADP|ACAD' | head -n1)
STATUS=$(cat /sys/class/power_supply/$POWER_SUPPLY/online)

# Estado actual
CURRENT=$(cat $GOV_FILE)

# Toggle manual
if [ "$1" == "toggle" ]; then
    if [ "$CURRENT" == "powersave" ]; then
        echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
    else
        echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
    fi
fi

# Auto mode (solo si no hay override manual)
if [ -z "$1" ]; then
    if [ "$STATUS" -eq 1 ]; then
        echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
    else
        echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
    fi
fi

# Output para Waybar
NEW=$(cat $GOV_FILE)

if [ "$NEW" == "performance" ]; then
    echo "⚡ Performance"
else
    echo "🔋 Powersave"
fi
