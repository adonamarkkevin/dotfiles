#!/bin/bash

# Get the hostname
hostname=$(hostnamectl --static)

# Define your hostnames
desktop_hostname="archlinux"
laptop_hostname="archbtw"

# Define monitors (updated for AMD)
monitor1="HDMI-A-0"
monitor2="DisplayPort-1"
laptop_monitor="eDP-1"

if [ "$hostname" = "$desktop_hostname" ]; then
    # Arrange displays: DP primary (right), HDMI secondary (left)
    xrandr --output "$monitor2" --primary --right-of "$monitor1"

    # Workspaces on primary (DP-1)
    i3-msg "workspace 1 output $monitor2"
    i3-msg "workspace 2 output $monitor2"
    i3-msg "workspace 3 output $monitor2"
    i3-msg "workspace 4 output $monitor2"
    i3-msg "workspace 5 output $monitor2"
    i3-msg "workspace 6 output $monitor2"
    i3-msg "workspace 7 output $monitor2"
    i3-msg "workspace 8 output $monitor2"
    i3-msg "workspace 9 output $monitor2"

    # Secondary monitor workspaces (HDMI)
    i3-msg "workspace 11 output $monitor1"
    i3-msg "workspace 12 output $monitor1"
    i3-msg "workspace 13 output $monitor1"
    i3-msg "workspace 14 output $monitor1"
    i3-msg "workspace 15 output $monitor1"
    i3-msg "workspace 16 output $monitor1"
    i3-msg "workspace 17 output $monitor1"
    i3-msg "workspace 18 output $monitor1"
    i3-msg "workspace 19 output $monitor1"
fi
