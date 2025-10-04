#!/bin/sh

# Get the monitor ID where the focused window is located
CURRENT_MONITOR=$(hyprctl activewindow -j | jq -r '.monitor')

# If no active window, fall back to the focused monitor
if [ -z "$CURRENT_MONITOR" ] || [ "$CURRENT_MONITOR" = "null" ]; then
    CURRENT_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .id')
fi

# Get the argument (workspace number or direction)
ARG=$1

# Determine the workspace number
if [[ "$ARG" == "next" ]] || [[ "$ARG" == "prev" ]]; then
    # Get current workspace on the focused monitor
    if [ "$CURRENT_MONITOR" -eq 0 ]; then
        CURRENT_WS=$(hyprctl monitors -j | jq -r ".[] | select(.id == $CURRENT_MONITOR) | .activeWorkspace.id")
    else
        # For monitor 1, subtract 10 to get the logical workspace number (11-20 -> 1-10)
        CURRENT_WS=$(hyprctl monitors -j | jq -r ".[] | select(.id == $CURRENT_MONITOR) | .activeWorkspace.id")
        CURRENT_WS=$((CURRENT_WS - 10))
    fi

    # Calculate next/prev workspace
    if [[ "$ARG" == "next" ]]; then
        WORKSPACE=$((CURRENT_WS + 1))
    else
        WORKSPACE=$((CURRENT_WS - 1))
    fi

    # Check limits and exit early if we're already at the boundary
    if [ "$WORKSPACE" -lt 1 ] || [ "$WORKSPACE" -gt 5 ]; then
        exit 0
    fi
else
    # Direct workspace number
    WORKSPACE=$ARG
fi

# Calculate the workspace for each monitor
# Monitor 0 (first): workspaces 1-10
# Monitor 1 (second): workspaces 11-20
MONITOR1_WS=$WORKSPACE
MONITOR2_WS=$((WORKSPACE + 10))

# Switch workspaces on both monitors
hyprctl dispatch workspace $MONITOR1_WS
hyprctl dispatch workspace $MONITOR2_WS

# Refocus the original monitor
hyprctl dispatch focusmonitor $CURRENT_MONITOR