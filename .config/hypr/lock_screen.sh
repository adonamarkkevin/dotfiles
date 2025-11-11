#!/bin/bash

# Swaylock screen lock script for Hyprland
# Uses swaylock with configuration from swaylock.conf

hostname=$(hostnamectl --static)

desktop_hostname="archlinux"
laptop_hostname="archbtw"

# Lock with swaylock using the config file
# The -f flag makes it fork (run in background)
# The config file handles appearance

if [ "$hostname" = "$desktop_hostname" ]; then
  # Desktop - optionally use background image
  swaylock -f -C ~/.config/hypr/swaylock.conf
  # Or with custom background:
  # swaylock -f -C ~/.config/hypr/swaylock.conf -i ~/backgrounds/1440p-dim-append-cyberpunk-city.png
elif [ "$hostname" = "$laptop_hostname" ]; then
  # Laptop - optionally use background image
  swaylock -f -C ~/.config/hypr/swaylock.conf
  # Or with custom background:
  # swaylock -f -C ~/.config/hypr/swaylock.conf -i ~/backgrounds/1080p-dim-cyberpunk-city.png
else
  # Fallback
  swaylock -f -C ~/.config/hypr/swaylock.conf
fi
