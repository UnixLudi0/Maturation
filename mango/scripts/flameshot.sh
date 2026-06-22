#!/usr/bin/bash

set -x
JSON=$(mmsg get focusing-client)

X=$(echo "$JSON" | grep -oP '"x":\s*\K\d+')
Y=$(echo "$JSON" | grep -oP '"y":\s*\K\d+')
W=$(echo "$JSON" | grep -oP '"width":\s*\K\d+')
H=$(echo "$JSON" | grep -oP '"height":\s*\K\d+')

QT_ENABLE_HIGHDPI_SCALING=0 flameshot gui --region "${W}x${H}+${X}+${Y}"
