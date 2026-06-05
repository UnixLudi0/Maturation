mkdir -p ../logs
exec > >(tee -a ../logs/base.log) 2>&1
set -euxo pipefail

sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman -Sy --noconfirm archlinux-keyring
sudo systemctl enable --now archlinux-keyring-wkd-sync.timer

#cachyos repos
curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
tar xvf cachyos-repo.tar.xz
cd cachyos-repo
sed -i 's/pacman -U/pacman -U --noconfirm/g' ./cachyos-repo.sh
sudo ./cachyos-repo.sh
cd ..
rm -r cachyos-repo && rm cachyos-repo.tar.xz

sudo pacman -Sy --noconfirm reflector
sudo reflector --verbose --country "$(curl -sSL 'https://ifconfig.co/country-iso')" -l 25 --sort age --save /etc/pacman.d/mirrorlist
sudo sed -i 's/\[options\]/\[options\]\nDisableDownloadTimeout/g' /etc/pacman.conf

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -sric
cd .. && rm -r yay

yay -S --noconfirm autoconf automake binutils bison debugedit fakeroot file findutils flex gawk gcc gettext grep groff gzip libtool m4 make pacman patch pkgconf sed texinfo which
yay -S --noconfirm linux-cachyos linux-cachyos-headers linux-zen linux-zen-headers
yay -S --noconfirm git cmake mkinitcpio-firmware
yay -S --noconfirm chwd
sudo chwd -a

sudo mkinitcpio -P
