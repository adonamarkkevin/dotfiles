#!/bin/bash

hostname=$(hostnamectl --static)

desktop_hostname="archlinux"
laptop_hostname="archbtw"

if [ "$hostname" = "$desktop_hostname" ]; then
  i3lock --nofork -i ~/backgrounds/dim-lockscrn-astronaut.png
elif [ "$hostname" = "$laptop_hostname" ]; then
  i3lock --nofork -i ~/backgrounds/1080p-dim-astronaut.png
else
  # Fallback in case hostname doesn't match
  i3lock --nofork
fi
