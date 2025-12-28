sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman-key --refresh-keys
sudo pacman -Sy archlinux-keyring
sudo systemctl enable --now archlinux-keyring-wkd-sync.timer

curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
tar xvf cachyos-repo.tar.xz && cd cachyos-repo
sudo ./cachyos-repo.sh
rm -r cachyos-repo

sudo reflector --verbose --country 'Russia' -l 25 --sort rate --save /etc/pacman.d/mirrorlist
sudo sed -i 's/\[options\]/\[options\]\nDisableDownloadTimeout/g' /etc/pacman.conf

yay -S linux-cachyos linux-cachyos-headers linux-zen linux-zen-headers
yay -S git base-devel mkinitcpio-firmware
if [[ "$HG_CPU" -eq "intel"]]; then
  yay -S --noconfirm intel-ucode
else
  yay -S --noconfirm amd-ucode

yay -S --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils egl-wayland










sudo mkinitcpio -P
