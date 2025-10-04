#!/bin/sh

# Get the active window's monitor
CURRENT_MONITOR=$(hyprctl activewindow -j | jq -r '.monitor')
WINDOW_ADDRESS=$(hyprctl activewindow -j | jq -r '.address')

# If no active window, exit
if [ -z "$CURRENT_MONITOR" ] || [ "$CURRENT_MONITOR" = "null" ]; then
    exit 0
fi

# Get the argument (next or prev)
ARG=$1

# Get current workspace
CURRENT_WS=$(hyprctl activewindow -j | jq -r '.workspace.id')

# Determine the logical workspace number (1-10 range)
if [ "$CURRENT_MONITOR" -eq 0 ]; then
    LOGICAL_WS=$CURRENT_WS
else
    # For monitor 1, subtract 10 to get logical workspace (11-20 -> 1-10)
    LOGICAL_WS=$((CURRENT_WS - 10))
fi

# Calculate next/prev workspace
if [[ "$ARG" == "next" ]]; then
    NEW_LOGICAL_WS=$((LOGICAL_WS + 1))
else
    NEW_LOGICAL_WS=$((LOGICAL_WS - 1))
fi

# Check limits and exit early if we're already at the boundary
if [ "$NEW_LOGICAL_WS" -lt 1 ] || [ "$NEW_LOGICAL_WS" -gt 5 ]; then
    exit 0
fi

# Calculate actual workspace number based on monitor
if [ "$CURRENT_MONITOR" -eq 0 ]; then
    TARGET_WS=$NEW_LOGICAL_WS
else
    TARGET_WS=$((NEW_LOGICAL_WS + 10))
fi

# Move the window to the target workspace
hyprctl dispatch movetoworkspace $TARGET_WS

# Switch to that workspace using the existing script
~/dotfiles/.config/hypr/switch_workspace.sh $NEW_LOGICAL_WS

hyprctl dispatch focuswindow address:$WINDOW_ADDRESS