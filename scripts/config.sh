#remove prewious variables
rm scripts/variables.sh

#generate & edit timezones lost as txt
timedatectl list-timezones > /tmp/timezones.txt
sed -i 's/^/#/' /tmp/timezones.txt
nano /tmp/timezones.txt

#edit locales
nano /etc/locale.gen

#generate variables.sh
cat << 'EOF' >> scripts/variables.sh
#!/bin/bash"
hostname="arch"
rootpass="toor"
username="user"
userpass="resu"
disktype="ssd"
EOF

echo "timezone=$(grep -Ev '^[[:space:]]*#|^[[:space:]]*$' /tmp/timezones.txt)" >> scripts/variables.sh
lsblk -dn -o NAME,TYPE | awk '$2=="disk" {print $1}' | sed 's|^|#disk=/dev/|' >> scripts/variables.sh

#firmware based settings
if [ -d /sys/firmware/efi ]; then
cat <<- EOF >> variables.sh
disklabel='echo -e "label: gpt\n size=5G, type=U\n size=+, type=L" | sfdisk $disk'
limine1='cp /usr/share/limine/BOOTX64.EFI /boot/limine && cp /usr/share/limine/BOOTX64.EFI /boot/EFI/BOOT/'
limine2="cat > /etc/pacman.d/hooks/99-limine.hook << 'EOF'"
limine3="efibootmgr --create --disk $disk --part 1 --label 'Limine' --loader '\limine\BOOTX64.EFI' --unicode"
EOF
    hook="Exec = /bin/sh -c '/usr/bin/cp /usr/share/limine/BOOTX64.EFI /boot/limine/ && /usr/bin/cp /usr/share/limine/BOOTX64.EFI /boot/EFI/BOOT/"
else
    cat <<- EOF >> variables.sh
disklabel='echo -e "label: dos\n size=5G, type=c, bootable\n size=+, type=L" | sfdisk $disk'
limine1="arch-chroot /mnt bash -c 'cp /usr/share/limine/limine-bios.sys /boot/limine/'"
limine2='arch-chroot /mnt bash -c "limine bios-install \"$disk\""'
limine3=arch-chroot /mnt bash -c "cat > /etc/pacman.d/hooks/99-limine.hook << 'EOF'"
EOF
    hook="Exec = /bin/sh -c '/usr/bin/limine bios-install $disk && /usr/bin/cp /usr/share/limine/limine-bios.sys /boot/limine/'"
fi

echo 'limine4="
[Trigger]
Operation = Install
Operation = Upgrade
Type = Package
Target = limine

[Action]
Description = Deploying Limine after upgrade...
When = PostTransaction
$hook
"' >> scripts/variables.sh

if [[ "$disk" =~ (nvme|mmcblk|loop) ]]; then
    echo 'part1="p1"' >> scripts/variables.sh
    echo 'part2="p2"' >> scripts/variables.sh
else
    echo 'part1="1"' >> scripts/variables.sh
    echo 'part2="2"' >> scripts/variables.sh
fi

#manual editing if required
nano scripts/variables.sh
source scripts/variables.sh
