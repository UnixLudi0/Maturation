#iniramfs
sudo sed -i 's/#COMPRESSION="lz4"/COMPRESSION="lz4"/g' /etc/mkinitcpio.conf
sudo sed -i 's/#COMPRESSION_OPTIONS=()/COMPRESSION_OPTIONS=(-9)/g' /etc/mkinitcpio.conf

#zram
yay -S zram-generator
cp HG_ROOT/config/zram-generator.conf /etc/systemd/zram-generator.conf
sudo systemctl daemon-reload
sudo systemctl start systemd-zram-setup@zram0.service

#earlyoom
yay -S earlyoom
sudo systemctl enable --now earlyoom

#ananicy
sudo pacman -S ananicy-cpp
sudo systemctl enable --now ananicy-cpp
git clone https://aur.archlinux.org/cachyos-ananicy-rules-git.git
cd cachyos-ananicy-rules-git
makepkg -sric
sudo systemctl restart ananicy-cpp
cd ..
rm cachyos-ananicy-rules-git

#trim for SSD
sudo systemctl enable fstrim.timer

#irqbalance
sudo pacman -S irqbalance
sudo systemctl enable --now irqbalance

#pipewire
sudo pacman -S pipewire-jack
echo " @audio - rtprio 98" > /etc/security/limits.d/20-rt-audio.conf
mkdir -p ~/.config/pipewire/pipewire.conf.d
