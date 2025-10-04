#!/bin/sh

# Get the monitor ID where the focused window is located
CURRENT_MONITOR=$(hyprctl activewindow -j | jq -r '.monitor')

# If no active window, fall back to the focused monitor
if [ -z "$CURRENT_MONITOR" ] || [ "$CURRENT_MONITOR" = "null" ]; then
    CURRENT_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .id')
fi

# Get the workspace number from the argument
WORKSPACE=$1

# Calculate the workspace for each monitor
# Monitor 0 (first): workspaces 1-10
# Monitor 1 (second): workspaces 11-20
if [ "$CURRENT_MONITOR" -eq 0 ]; then
    MONITOR1_WS=$WORKSPACE
    MONITOR2_WS=$((WORKSPACE + 10))
else
    MONITOR1_WS=$WORKSPACE
    MONITOR2_WS=$((WORKSPACE + 10))
fi

# Switch workspaces on both monitors
hyprctl dispatch workspace $MONITOR1_WS
hyprctl dispatch workspace $MONITOR2_WS

# Refocus the original monitor
hyprctl dispatch focusmonitor $CURRENT_MONITOR