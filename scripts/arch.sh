set -euo pipefail

timedatectl set-ntp true

BITS=$(cat /sys/firmware/efi/fw_platform_size 2>/dev/null)
if [[ "$BITS" == "32" ]] || [[ "$BITS" == "64" ]]; then
    FIRMWARE="uefi"
elif [[ -z "$BITS" ]]; then
    FIRMWARE="bios"
else
    echo -n "Failed to detect firmware. Exit..."
    exit 1
fi

echo "Choose disk:"
lsblk -dn -o NAME,TYPE | awk '$2=="disk" {count++; print count") "$1}'
echo "All data on selected disk will be wiped!"
echo -n "Input disk number: "
read num
[[ "$num" =~ ^[0-9]+$ ]] || { echo "Invalid input"; exit 1; }
disk="/dev/$(lsblk -dn -o NAME,TYPE | awk '$2=="disk"{print $1}' | sed -n "${num}p")"
echo "Will be used disk: $disk"
wipefs -a "$disk"
echo -n "Disk wiped!"

if [[ "$FIRMWARE" == "uefi" ]]; then
    echo -e "g\nn\n\n\n+5G\nt\n1\nn\n\n\n\nw\n" | fdisk "$disk"
    partprobe "$disk"
fi
if [[ "$FIRMWARE" == "bios" ]]; then
    echo -e 'o\nn\np\n1\n\n+1G\na\nn\np\n2\n\n\nw' | fdisk "$disk"
    partprobe "$disk"
fi

sleep 1

if [[ "$disk" =~ (nvme|mmcblk|loop) ]]; then
    part1="p1"
    part2="p2"
else
    part1="1"
    part2="2"
fi

mkfs.fat -F 32 "$disk$part1"
mkfs.btrfs -f -L btrfs "$disk$part2"
uuid=$(blkid -s UUID -o value "$disk$part2")
if [[ -z "$uuid" ]]; then
    echo "Failed to get UUID. Exit..."
    exit 1
fi

mount "$disk$part2" /mnt
cd /mnt
btrfs subvolume create @
btrfs subvolume create @home
cd /
umount /mnt

mount -o compress=zstd,subvol=@ "$disk$part2" /mnt
mkdir -p /mnt/home
mount -o compress=zstd,subvol=@home "$disk$part2" /mnt/home
mkdir -p /mnt/boot
mount "$disk$part1" /mnt/boot

pacman -Sy --noconfirm reflector
reflector --verbose --country "$(curl -sSL 'https://ifconfig.co/country-iso')" --latest 25 --sort age --save /etc/pacman.d/mirrorlist
pacstrap -K /mnt base base-devel linux-firmware linux-zen linux-zen-headers neovim git kbd btrfs-progs networkmanager
genfstab -U /mnt > /mnt/etc/fstab
arch-chroot /mnt bash -c 'ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime'
arch-chroot /mnt bash -c 'hwclock --systohc'
arch-chroot /mnt bash -c "sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen"
arch-chroot /mnt bash -c "sed -i 's/^#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen"
arch-chroot /mnt bash -c 'locale-gen'
arch-chroot /mnt bash -c 'echo "LANG=ru_RU.UTF-8" > /etc/locale.conf'
arch-chroot /mnt bash -c 'echo "KEYMAP=ru" >> /etc/vconsole.conf'
arch-chroot /mnt bash -c 'echo "FONT=cyr-sun16" >> /etc/vconsole.conf'
arch-chroot /mnt bash -c 'systemctl enable NetworkManager'
echo -n "Enter hostname: "
read hostname
arch-chroot /mnt bash -c "echo \"$hostname\" > /etc/hostname"
arch-chroot /mnt bash -c 'mkinitcpio -P'
echo -n "Enter root password: "
read rootpass
echo -e "$rootpass\n$rootpass" | arch-chroot /mnt passwd

echo -n "Enter username: "
read username
arch-chroot /mnt bash -c "useradd -m -G wheel -s /bin/bash \"$username\""
arch-chroot /mnt bash -c "echo \"$username ALL=(ALL:ALL) ALL\" | EDITOR='tee -a' visudo"
echo -n "Enter user password: "
read userpass
echo -e "$userpass\n$userpass" | arch-chroot /mnt passwd $username

#limine bootloader
arch-chroot /mnt bash -c 'pacman -S --noconfirm limine efibootmgr'
mkdir -p /mnt/boot/limine
mkdir -p /mnt/etc/pacman.d/hooks
mkdir -p /mnt/boot/EFI/BOOT

if [[ "$FIRMWARE" == "uefi" ]]; then
    arch-chroot /mnt bash -c 'cp /usr/share/limine/BOOTX64.EFI /boot/limine/'
    arch-chroot /mnt bash -c 'cp /usr/share/limine/BOOTX64.EFI /boot/EFI/BOOT/'
    arch-chroot /mnt bash -c 'cat > /etc/pacman.d/hooks/99-limine.hook << "EOF"
    [Trigger]
    Operation = Install
    Operation = Upgrade
    Type = Package
    Target = limine              

    [Action]
    Description = Deploying Limine after upgrade...
    When = PostTransaction
    Exec = /bin/sh -c "/usr/bin/cp /usr/share/limine/BOOTX64.EFI /boot/limine/ && /usr/bin/cp /usr/share/limine/BOOTX64.EFI /boot/EFI/BOOT/"
    EOF'
    arch-chroot /mnt bash -c "efibootmgr --create --disk $disk --part 1 --label 'Limine' --loader '\limine\BOOTX64.EFI' --unicode"
fi

if [[ "$FIRMWARE" == "bios" ]]; then
    arch-chroot /mnt bash -c 'cp /usr/share/limine/limine-bios.sys /boot/limine/'
    arch-chroot /mnt bash -c "limine bios-install \"$disk\""
    arch-chroot /mnt bash -c 'cat > /etc/pacman.d/hooks/99-limine.hook << "EOF"
    [Trigger]
    Operation = Install
    Operation = Upgrade
    Type = Package
    Target = limine              
    
    [Action]
    Description = Deploying Limine after upgrade...
    When = PostTransaction
    Exec = /bin/sh -c "/usr/bin/limine bios-install $disk && /usr/bin/cp /usr/share/limine/limine-bios.sys /boot/limine/"
    EOF'
fi

arch-chroot /mnt bash -c "cat > /boot/limine/limine.conf << EOF
timeout: 5

/Arch Linux
    protocol: linux
    path: boot():/vmlinuz-linux-zen
    cmdline: root=UUID=$uuid rw rootflags=subvol=@
    module_path: boot():/initramfs-linux-zen.img
/Arch Linux (fallback)
    protocol: linux
    path: boot():/vmlinuz-linux-zen
    cmdline: root=UUID=$uuid rw rootflags=subvol=@
    module_path: boot():/initramfs-linux-zen-fallback.img
EOF"

arch-chroot /mnt bash -c "git clone https://github.com/UnixLudi0/Maturation /home/$username/Maturation"
arch-chroot /mnt bash -c "chown -R $username:$username /home/$username/Maturation"
reboot
