#!/usr/bin/env bash

THRESHOLD=600000  # 10 minutes in milliseconds
INTERVAL=30        # seconds
locked=false        # flag to track lock state

while true; do
    idle=$(xssstate -i)

    if (( idle > THRESHOLD )) && [ "$locked" = false ]; then
        echo "Idle detected! Locking screen..."
        dm-tool lock
        locked=true
    elif (( idle < THRESHOLD )); then
        # Reset lock flag if user is active again
        locked=false
    fi

    sleep $INTERVAL
done
