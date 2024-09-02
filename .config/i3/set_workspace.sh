#!/bin/bash

# Get the hostname
hostname=$(hostnamectl --static)

# Define your hostnames
desktop_hostname="archlinux"
laptop_hostname="archbtw"

# Define monitors
monitor1="HDMI-0"
monitor2="DP-1"
laptop_monitor="eDP-1"

if [ "$hostname" = "$desktop_hostname" ]; then
    # Desktop configuration
    i3-msg "workspace 1 output $monitor1"
    i3-msg "workspace 2 output $monitor1"
    i3-msg "workspace 3 output $monitor1"
    i3-msg "workspace 4 output $monitor1"
    i3-msg "workspace 5 output $monitor1"
    i3-msg "workspace 6 output $monitor1"
    i3-msg "workspace 7 output $monitor1"
    i3-msg "workspace 8 output $monitor1"
    i3-msg "workspace 9 output $monitor1"

    # Secondary monitor workspaces
    i3-msg "workspace 11 output $monitor2"
    i3-msg "workspace 12 output $monitor2"
    i3-msg "workspace 13 output $monitor2"
    i3-msg "workspace 14 output $monitor2"
    i3-msg "workspace 15 output $monitor2"
    i3-msg "workspace 16 output $monitor2"
    i3-msg "workspace 17 output $monitor2"
    i3-msg "workspace 18 output $monitor2"
    i3-msg "workspace 19 output $monitor2"
elif [ "$hostname" = "$laptop_hostname" ]; then
    # Laptop configuration
    i3-msg "workspace 1 output $laptop_monitor"
    i3-msg "workspace 2 output $laptop_monitor"
    i3-msg "workspace 3 output $laptop_monitor"
    i3-msg "workspace 4 output $laptop_monitor"
    i3-msg "workspace 5 output $laptop_monitor"
    i3-msg "workspace 6 output $laptop_monitor"
    i3-msg "workspace 7 output $laptop_monitor"
    i3-msg "workspace 8 output $laptop_monitor"
    i3-msg "workspace 9 output $laptop_monitor"
fi
