#!/bin/sh

# Get the window address passed as argument
WINDOW_ADDRESS=$1

# Get the window's workspace ID
WINDOW_WS=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$WINDOW_ADDRESS\") | .workspace.id")

# If window not found, exit
if [ -z "$WINDOW_WS" ] || [ "$WINDOW_WS" = "null" ]; then
    exit 0
fi

# Determine the logical workspace number (1-5)
if [ "$WINDOW_WS" -le 10 ]; then
    LOGICAL_WS=$WINDOW_WS
else
    # For workspaces 11-20, get the logical number (11-20 -> 1-10)
    LOGICAL_WS=$((WINDOW_WS - 10))
fi

# Switch to that workspace group using our existing script
~/dotfiles/.config/hypr/switch_workspace.sh $LOGICAL_WS

# Focus the window
hyprctl dispatch focuswindow address:$WINDOW_ADDRESS