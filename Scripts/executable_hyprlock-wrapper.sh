#!/bin/bash

# Auto-detect correct env
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export WAYLAND_DISPLAY=$(ls /run/user/$(id -u)/wayland-* 2>/dev/null | head -n 1 | xargs basename)

# Wait briefly to ensure Hyprland is ready
sleep 1

# Only lock if Hyprland is running
if pgrep Hyprland >/dev/null; then
  /usr/bin/hyprlock
fi
