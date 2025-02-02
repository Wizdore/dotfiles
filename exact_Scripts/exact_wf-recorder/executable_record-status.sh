#!/usr/bin/env bash

# File to store start time
START_TIME_FILE="/tmp/wf_recorder_start_time"

# Check if wf-recorder is running
if pgrep -x "wf-recorder" > /dev/null; then
    if [ ! -f "$START_TIME_FILE" ]; then
        date +%s > "$START_TIME_FILE"
    fi

    START_TIME=$(cat "$START_TIME_FILE")
    CURRENT_TIME=$(date +%s)
    ELAPSED_TIME=$((CURRENT_TIME - START_TIME))

    # Convert seconds to HH:MM:SS format
    TIME_FORMATTED=$(printf "%02d:%02d:%02d" $((ELAPSED_TIME/3600)) $(((ELAPSED_TIME/60)%60)) $((ELAPSED_TIME%60)))

    echo "🔴 $TIME_FORMATTED"
else
    rm -f "$START_TIME_FILE"
fi

