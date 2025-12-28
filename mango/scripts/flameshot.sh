#!/usr/bin/bash

{
    read _ _ X
    read _ _ Y
    read _ _ W
    read _ _ H
} < <(mmsg -x)

QT_ENABLE_HIGHDPI_SCALING=0 flameshot gui --region "${W}x${H}+${X}+${Y}"
