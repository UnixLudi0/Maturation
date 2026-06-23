#!/bin/bash
enable_notifications=true

mode=$(mmsg get keymode | grep -o '"keymode":"[^"]*"' | cut -d'"' -f4)

if [[ "$mode" = "default" ]]; then
    mmsg dispatch setkeymode,special
    [[ "$enable_notifications" = true ]] && notify-send "Keymode: Special"
elif [[ "$mode" = "special" ]]; then
    mmsg dispatch setkeymode,default
    [[ "$enable_notifications" = true ]] && notify-send "Keymode: Default"
fi
