#!/bin/bash

hostname=$(hostnamectl --static)

desktop_hostname="archlinux"
laptop_hostname="archbtw"

if [ "$hostname" = "$desktop_hostname" ]; then
  i3lock --nofork -i ~/backgrounds/1440p-dim-append-cyberpunk-city.png
elif [ "$hostname" = "$laptop_hostname" ]; then
  i3lock --nofork -i ~/backgrounds/1080p-dim-cyberpunk-city.png
else
  # Fallback in case hostname doesn't match
  i3lock --nofork
fi
