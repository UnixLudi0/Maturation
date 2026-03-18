#!/bin/bash

enable_notifications=true
mode=$(mmsg -b | awk '{print $NF}')

if [[ "$mode" = "default" && $enable_notifications = true ]]; then
    mmsg -d setkeymode,special
    notify-send "Keymode: Special"
elif [[ "$mode" = "special" && $enable_notifications = true ]]; then
    mmsg -d setkeymode,default
    notify-send "Keymode: Default"
elif [[ "$mode" = "default" && $enable_notifications = false ]]; then
    mmsg -d setkeymode,special
elif [[ "$mode" = "special" && $enable_notifications = false ]]; then
    mmsg -d setkeymode,default
fi
