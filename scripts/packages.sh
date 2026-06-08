#!/bin/bash

packages=""

#mango
packages+=" wireplumber libgtop bluez bluez-utils networkmanager dart-sass upower gvfs gtksourceview3 libsoup3"
packages+=" mangowm-git"
packages+=" xdg-desktop-portal-wlr"
packages+=" waybar"
packages+=" wl-clip-persist"
packages+=" cliphist"
packages+=" wl-clipboard"
packages+=" wlsunset"
packages+=" soteria-git"
packages+=" pamixer"
packages+=" wlr-dpms"
packages+=" sway-audio-idle-inhibit-git"
packages+=" swayidle"
packages+=" dimland-git"
packages+=" brightnessctl"
packages+=" swayosd"
packages+=" wlr-randr"
packages+=" swaylock-effects-git"
packages+=" wlogout"
packages+=" sox"
packages+=" dimland-git"

#yazi
packages+=" yazi ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick"

#neovim 
packages+=" neovim"

#mpv
packages+=" mpv"

#losslesscut
packages+=" losslesscut-bin"

#gimp
packages+=" gimp"

#flameshot
packages+=" flameshot"

#libreoffice-still
packages+=" libreoffice-still"

#btop
packages+=" btop"

#steam
packages+=" steam"

#vesktop
packages+=" vesktop"

#telegram
packages+=" telegram-desktop"

#pavucontrol
packages+=" pavucontrol"

#firefox
packages+=" firefox"

#fuzzel
packages+=" fuzzel"

#bitwarden
packages+=" bitwarden"

#copyq
packages+=" copyq"

#qbittorrent
packages+=" qbittorrent"

#thunderbird
packages+=" thunderbird"

#swaync
packages+=" swaync"

#keyd
packages+=" keyd"

#zsh
packages+=" zsh"

#obs
packages+=" obs"

#bleachbit
packages+=" bleachbit"

#foot
packages+=" foot"

#fastfetch
packages+=" fastfetch"

packages+=" noto-fonts"
packages+=" woff2-font-awesome"
packages+=" ttf-nerd-fonts-symbols-common"
packages+=" ttf-jetbrains-mono-nerd"

yay -S --noconfirm $packages
