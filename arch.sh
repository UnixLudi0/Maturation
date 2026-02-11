timedatectl

echo "Choose disk:"
lsblk | grep disk | awk '{print NR") "$1}'
echo -n "Input disk number: "
read num
disk="/dev/$(lsblk | grep " disk" | sed -n "${num}p" | awk '{print $1}')"
echo "Will be used disk: $disk"
echo -e "g\nn\n\n\n+1G\nt\n1\nn\n\n\n\nw\n" | sudo fdisk $disk
sleep 3

if [[ -e "${disk}p1" ]]; then
    part1="${disk}p1"
    part2="${disk}p2"
else
    part1="${disk}1"
    part2="${disk}2"
fi

mkfs.fat -F 32 $part1
mkfs.btrfs -L mylabel $part2
uuid=$(blkid -s UUID -o value $part2)

mount $part2 /mnt
cd /mnt
btrfs subvolume create @
btrfs subvolume create @home
cd /
umount /mnt

mount -o compress=zstd,subvol=@ $part2 /mnt
mkdir -p /mnt/home
mount -o compress=zstd,subvol=@home $part2 /mnt/home
mkdir -p /mnt/boot/efi
mount $part1 /mnt/boot/efi

curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
tar xvf cachyos-repo.tar.xz && cd cachyos-repo
sudo ./cachyos-repo.sh

pacstrap -M -P -c -i /mnt base linux-cachyos cachyos-keyring cachyos-mirrorlist cachyos-v3-mirrorlist
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
hwclock --systohc
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
sed -i 's/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
echo "LANG=ru_RU.UTF-8" > /etc/locale.conf
echo "KEYMAP=ru" > /etc/vconsole.conf
echo "FONT=cyr-sun16" >> /etc/vconsole.conf
echo -n "Enter hostname: "
read hostname
echo $hostname > /etc/hostname
mkinitcpio -P
passwd

#limine bootloader
pacman -S limine efibootmgr
mkdir -p /boot/efi/EFI/limine
cp /usr/share/limine/BOOTX64.EFI /boot/efi/EFI/limine/

efibootmgr --create --disk $disk --part $part1 --label "Limine" --loader '/EFI/limine/BOOTX64.EFI' --unicode
cat > /boot/efi/EFI/limine/limine.conf << 'EOF'
timeout: 5

/Arch Linux
    protocol: linux
    path: uuid:/boot/vmlinuz-linux
    cmdline: root=UUID=uuid rw
    module_path: uuid:/boot/initramfs-linux.img

/Windows
    protocol: efi
    path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
EOF
cat > /etc/pacman.d/hooks/99-limine.hook << 'EOF'
[Trigger]
Operation = Install
Operation = Upgrade
Type = Package
Target = limine              

[Action]
Description = Deploying Limine after upgrade...
When = PostTransaction
Exec = /usr/bin/cp /usr/share/limine/BOOTX64.EFI /boot/efi/EFI/limine/
EOF
