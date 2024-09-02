#!/bin/bash

# Identify your Kensington SlimBlade device ID
device_id=$(xinput list | grep 'Kensington Slimblade Trackball' | awk '{print $6}' | sed 's/id=//')


if [ -n "$device_id" ]; then
  # Swap button 8 (back) with button 3 (right-click)
  xinput set-button-map $device_id 1 2 8 4 5 6 7 3 9
fi
