#!/bin/bash

# Hyprland Autostart Script
# Migrated from i3 autostart

# Set wallpaper with hyprpaper (Wayland alternative to feh)
hyprpaper &

# Swap trackball buttons
sh ~/swap_trackball_btn.sh &

# Clean up neovim
sh ~/dotfiles/.config/i3/cleanup_nvim.sh &

# Network Manager applet
nm-applet --indicator &

# Waybar (Wayland alternative to polybar)
# Make sure waybar is installed: pacman -S waybar
killall waybar
waybar &

# Start applications on specific workspaces
sleep 1  # Give Hyprland a moment to initialize

# Open Brave in workspace 1
hyprctl dispatch workspace 1
hyprctl dispatch exec brave &

# Open Google Chrome in workspace 2
hyprctl dispatch workspace 2
hyprctl dispatch exec google-chrome-stable &

# Return to workspace 1
sleep 2
hyprctl dispatch workspace 1

# Disable screen blanking
# Note: On Wayland, this might need different commands
# For now, using swayidle or hypridle instead
# swayidle -w timeout 0 'swaylock' &
