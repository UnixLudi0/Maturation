1) Настройка сети
iwctl
device list
station устройство connect SSID

2) Разделы
mkfs.ext4 /dev/sda5
mkswap /dev/sda6
mount /dev/sda5 /mnt
swapon /dev/sda6

3) Пакеты и система
reflector
pacstrap -K /mnt base linux-zen linux-firmware sudo nano
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
hwclock --systohc
nano /etc/locale.gen
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8
locale-gen
nano /etc/locale.conf
LANG=ru_RU.UTF-8
nano /etc/vconsole.conf
KEYMAP=ru
FONT=cyr-sun16
nano /etc/hostname
mkinitcpio -P
passwd

4) Загрузчик
pacman -S grub efibootmgr
mount --mkdir /dev/sda2 /boot/efi 
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi --removable
grub-mkconfig -o /boot/grub/grub.cfg

