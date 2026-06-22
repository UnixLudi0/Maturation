#disk selection
lsblk -dn -o NAME,TYPE | awk '$2=="disk" {print $1}' >> ./variables.sh

#firmware detection
if [ -d /sys/firmware/efi ]; then
    disklabel='echo -e ",5G,U\n,+,\n" | sfdisk --label gpt "$disk"'
    limine1='cp /usr/share/limine/BOOTX64.EFI /boot/limine && cp /usr/share/limine/BOOTX64.EFI /boot/EFI/BOOT/'
    limine2="cat > /etc/pacman.d/hooks/99-limine.hook << 'EOF'"
    limine3="efibootmgr --create --disk $disk --part 1 --label 'Limine' --loader '\limine\BOOTX64.EFI' --unicode"
    hook="Exec = /bin/sh -c '/usr/bin/cp /usr/share/limine/BOOTX64.EFI /boot/limine/ && /usr/bin/cp /usr/share/limine/BOOTX64.EFI /boot/EFI/BOOT/"
else
    disklabel='echo -e ",5G,L,*\n,+,\n" | sfdisk --label dos "$disk"'
    limine1="arch-chroot /mnt bash -c 'cp /usr/share/limine/limine-bios.sys /boot/limine/'"
    limine2='arch-chroot /mnt bash -c "limine bios-install \"$disk\""'
    limine3=arch-chroot /mnt bash -c "cat > /etc/pacman.d/hooks/99-limine.hook << 'EOF'"
    hook="Exec = /bin/sh -c '/usr/bin/limine bios-install $disk && /usr/bin/cp /usr/share/limine/limine-bios.sys /boot/limine/'"
fi

if [[ "$disk" =~ (nvme|mmcblk|loop) ]]; then
    part1="p1"
    part2="p2"
else
    part1="1"
    part2="2"
fi

limine4="
[Trigger]
Operation = Install
Operation = Upgrade
Type = Package
Target = limine

[Action]
Description = Deploying Limine after upgrade...
When = PostTransaction
$hook
"

timedatectl list-timezones > /tmp/timezones.txt
sed -i 's/^/#/' /tmp/timezones.txt
nano /tmp/timezones.txt
grep -Ev '^[[:space:]]*#|^[[:space:]]*$' /tmp/timezones.txt >> ./variables.sh
nano /etc/locale.gen

nano ./variables.sh
source ./variables.sh

