timedatectl

echo "Choose disk:"
lsblk | grep disk | awk '{print NR") "$1}'
echo -n "Input disk number: "
read num
disk="/dev/$(lsblk | grep " disk" | sed -n "${num}p" | awk '{print $1}')"
echo "Will be used disk: $disk"
echo -e "g\nn\n\n\n+5G\nt\n1\nn\n\n\n\nw\n" | sudo fdisk $disk
sleep 3

if [[ -e "${disk}p1" ]]; then
    part1="p1"
    part2="p2"
else
    part1="1"
    part2="2"
fi

mkfs.fat -F 32 "$disk$part1"
mkfs.btrfs -L mylabel "$disk$part2"
uuid=$(blkid -s UUID -o value "$disk$part2")

mount "$disk$part2" /mnt
cd /mnt
btrfs subvolume create @
btrfs subvolume create @home
cd /
umount /mnt

mount -o compress=zstd,subvol=@ "$disk$part2" /mnt
mkdir -p /mnt/home
mount -o compress=zstd,subvol=@home "$disk$part2" /mnt/home
mkdir -p /mnt/boot/efi
mount "$disk$part1" /mnt/boot

sudo reflector --verbose --country "$(curl -sSL 'https://ifconfig.co/country-iso')" --latest 25 --sort age --save /etc/pacman.d/mirrorlist
pacstrap -K /mnt base base-devel linux-firmware linux-zen linux-zen-headers neovim git
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
arch-chroot /mnt hwclock --systohc
arch-chroot /mnt sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
arch-chroot /mnt sed -i 's/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/g' /etc/locale.gen
arch-chroot /mnt locale-gen
arch-chroot /mnt echo "LANG=ru_RU.UTF-8" > /etc/locale.conf
arch-chroot /mnt echo "KEYMAP=ru" > /etc/vconsole.conf
arch-chroot /mnt echo "FONT=cyr-sun16" >> /etc/vconsole.conf
echo -n "Enter hostname: "
read hostname
arch-chroot /mnt echo $hostname > /etc/hostname
arch-chroot /mnt mkinitcpio -P
echo -n "Enter root password: "
read rootpass
echo -e "$rootpass\n$rootpass" | arch-chroot /mnt passwd

echo -n "Enter username: "
read username
arch-chroot /mnt useradd -m -G wheel -s /bin/bash $username
echo -n "Enter user password: "
read userpass
echo -e "$userpass\n$userpass" | arch-chroot /mnt passwd $username
arch-chroot /mnt git clone https://github.com/UnixLudi0/Maturation "/home/$username/Maturation"
arch-chroot /mnt chown -R $username:$username "/home/$username/Maturation"

#limine bootloader
arch-chroot /mnt pacman -S limine efibootmgr
arch-chroot /mnt mkdir -p /boot/EFI/limine
arch-chroot /mnt cp /usr/share/limine/BOOTX64.EFI /boot/EFI/limine/

arch-chroot /mnt efibootmgr --create --disk $disk --part 1 --label "Limine" --loader '/limine/BOOTX64.EFI' --unicode
arch-chroot /mnt bash -c "cat > /boot/EFI/limine/limine.conf" << EOF
timeout: 5

/Arch Linux
    protocol: linux
    path: boot():/vmlinuz-linux-zen
    cmdline: root=UUID=$uuid rw
    module_path: boot():/initramfs-linux-zen.img
EOF
arch-chroot /mnt bash -c "cat > /etc/pacman.d/hooks/99-limine.hook" << EOF
[Trigger]
Operation = Install
Operation = Upgrade
Type = Package
Target = limine              

[Action]
Description = Deploying Limine after upgrade...
When = PostTransaction
Exec = /usr/bin/cp /usr/share/limine/BOOTX64.EFI /boot/EFI/limine/
EOF
reboot
