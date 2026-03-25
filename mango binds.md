---
tags:
создал заметку: 2026-03-22 20:25
aliases:
  - mango keymodes
---
# Default `keymode`

| type of bind | Bind           | action                          | comment                    |
| ------------ | -------------- | ------------------------------- | -------------------------- |
| bind         | super+w        | change `keymode`                |                            |
| bind         | alt+shift+h    | switch focus to left monitor    |                            |
| bind         | alt+shift+l    | switch focus to right monitor   |                            |
| bind         | alt+shift+k    | switch focus to top monitor     |                            |
| bind         | alt+shift+j    | switch window to bottom monitor |                            |
| bind         | alt+h          | switch window to left monitor   | // special(?)              |
| bind         | alt+l          | switch window to right monitor  | // special(?)              |
| bind         | alt+k          | switch window to top monitor    | // special(?)              |
| bind         | alt+j          | switch window to bottom monitor | // special(?)              |
| mousebind    | None, btn_left | `toggleoverview 1`              | не работает по-моему       |
| mousebind    | None, btn_left | `toggleoverview 0`              | не работает по-моему       |
| axisbind     | super+up       | viewtoleft_have_client          | переключает на окно влево  |
| axisbind     | super+down     | viewtoright_have_client         | переключает на окно вправо |

# Special `keymode`

| type of bind | Bind          | action                         | comment |
| ------------ | ------------- | ------------------------------ | ------- |
| bind         | super+w       | change `keymode`               |         |
| bind         | super+t       | set tile `layout`              |         |
| bind         | super+shift+t | set vertical tile `layout`     |         |
| bind         | super+c       | set center tile `layout`       |         |
| bind         | super+r       | set right tile `layout`        |         |
| bind         | super+s       | set scroller `layout`          |         |
| bind         | super+shift+s | set vertical scroller `layout` |         |
| bind         | super+m       | set monocle `layout`           |         |
| bind         | super+g       | set grid `layout`              |         |
| bind         | super+shift+g | set vertical grid `layout`     |         |
| bind         | super+d       | set deck `layout`              |         |
| bind         | super+shift+d | set vertical deck `layout`     |         |
| bind         | super+x       | set tgmix `layout`             |         |
| bind         | super+h       | resize window to left          |         |
| bind         | super+j       | resize window to down          |         |
| bind         | super+k       | resize window to up            |         |
| bind         | super+l       | resize window to right         |         |
