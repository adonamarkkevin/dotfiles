#!/bin/bash

# Power menu using wofi

options="⏻ Shutdown\n⏾ Suspend\n Reboot\n Lock\n󰍃 Logout"

chosen=$(echo -e "$options" | wofi --dmenu -i -p "Power Menu" --width 250 --height 200)

case $chosen in
    "⏻ Shutdown")
        systemctl poweroff
        ;;
    "⏾ Suspend")
        systemctl suspend
        ;;
    " Reboot")
        systemctl reboot
        ;;
    " Lock")
        sh ~/dotfiles/.config/i3/lock_screen.sh
        ;;
    "󰍃 Logout")
        hyprctl dispatch exit
        ;;
esac
