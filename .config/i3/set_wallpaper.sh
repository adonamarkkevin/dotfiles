#!/bin/bash

hostname=$(hostnamectl --static)

desktop_hostname="archlinux"
laptop_hostname="archbtw"

if [ "$hostname" = "$desktop_hostname" ]; then
  feh --bg-scale ~/backgrounds/1440p-cyberpunk-city.png
elif [ "$hostname" = "$laptop_hostname" ]; then
  feh --bg-scale ~/backgrounds/1080p-cyberpunk-city.png
fi

