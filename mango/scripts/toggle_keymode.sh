#!/bin/bash

mode=$(mmsg -b | awk '{print $NF}')

if [ "$mode" == "default" ]; then
    mmsg -d setkeymode,special
else
    mmsg -d setkeymode,default
fi
