#!/bin/bash

hostname=$(hostnamectl --static)

desktop_hostname="archlinux"
laptop_hostname="archbtw"

if [ "$hostname" = "$desktop_hostname" ]; then
  feh --bg-scale ~/backgrounds/1440pastronaut.png
elif [ "$hostname" = "$laptop_hostname" ]; then
  feh --bg-scale ~/backgrounds/1080p-astronaut.png
fi

