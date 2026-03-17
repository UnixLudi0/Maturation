#!/bin/bash
mode=$(mmsg -b | grep keymode | awk '{print $3}' | head -1)
echo "$mode" >> /tmp/mango_debug.log
if [ "$mode" = "default" ]; then
    mmsg -d setkeymode,special
else
    mmsg -d setkeymode,default
fi
