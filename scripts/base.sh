#!/bin/bash

sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman -Sy --noconfirm archlinux-keyring
sudo systemctl enable --now archlinux-keyring-wkd-sync.timer

#cachyos repos
curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o /tmp/cachyos-repo.tar.xz
tar xvf /tmp/cachyos-repo.tar.xz -C /tmp/
sed -i '/set -e/a pacman() { /usr/bin/pacman "$@" --noconfirm; }' /tmp/cachyos-repo/cachyos-repo.sh
sudo /tmp/cachyos-repo/cachyos-repo.sh

sudo pacman -Sy --noconfirm reflector
sudo reflector --verbose --country "$(curl -sSL 'https://ifconfig.co/country-iso')" -l 25 --sort age --save /etc/pacman.d/mirrorlist
sudo sed -i 's/\[options\]/\[options\]\nDisableDownloadTimeout/g' /etc/pacman.conf

sudo pacman -S --noconfirm autoconf automake binutils bison debugedit fakeroot file findutils flex gawk gcc gettext grep groff gzip libtool m4 make pacman patch pkgconf sed texinfo which

git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -sric --noconfirm
cd

yay -S --noconfirm linux-cachyos linux-cachyos-headers linux-zen linux-zen-headers
yay -S --noconfirm git cmake mkinitcpio-firmware
yay -S --noconfirm chwd
sudo chwd -a

yay
sudo mkinitcpio -P
