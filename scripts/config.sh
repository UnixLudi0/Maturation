#remove prewious variables
> scripts/variables.sh

#generate variables.sh
cat << 'EOF' >> scripts/variables.sh
#!/bin/bash
hostname="arch"
rootpass="toor"
username="user"
userpass="resu"
disktype="ssd"
EOF

#disk
lsblk -dn -o NAME | awk '$1 ~ /^(sd[a-z]|nvme[0-9]|vd[a-z]|mmcblk[0-9])/' | while read -r disk; do 

    echo "#disk=/dev/$disk" >> scripts/variables.sh

    if [[ "$disk" =~ (nvme|mmcblk) ]]; then
        echo "#part1=p1" >> scripts/variables.sh
        echo "#part2=p2" >> scripts/variables.sh
    else
        echo "#part1=1" >> scripts/variables.sh
        echo "#part2=2" >> scripts/variables.sh
    fi

    echo "" >> scripts/variables.sh
done

#generate & edit timezones lost as txt
timedatectl list-timezones > /tmp/timezones.txt
sed -i 's/^/#/' /tmp/timezones.txt
nano /tmp/timezones.txt

#edit locales
nano /etc/locale.gen

#timezone
echo "timezone=$(grep -Ev '^[[:space:]]*#|^[[:space:]]*$' /tmp/timezones.txt)" >> scripts/variables.sh

#firmware based settings
if [ -d /sys/firmware/efi ]; then
    cat << 'EOF' >> scripts/variables.sh
disklabel='echo -e "label: gpt\n size=5G, type=U\n size=+, type=L" | sfdisk $disk'
limine1="mkdir -p /boot/EFI/BOOT"
limine2="cp /usr/share/limine/BOOTX64.EFI /boot/EFI/BOOT/BOOTX64.EFI"
limine3="efibootmgr --create --disk $disk --part 1 --label 'Arch Linux Limine Boot Loader' --loader '\EFI\BOOT\BOOTX64.EFI' --unicode"
limine4="Exec = /usr/bin/cp /usr/share/limine/BOOTX64.EFI /boot/EFI/BOOT/BOOTX64.EFI"
EOF
else
    cat << 'EOF' >> scripts/variables.sh
disklabel='echo -e "label: dos\n size=5G, type=c, bootable\n size=+, type=L" | sfdisk $disk'
limine1="mkdir -p /boot/limine"
limine2="cp /usr/share/limine/limine-bios.sys /boot/limine/"
limine3="limine bios-install $disk"
limine4='Exec = /bin/sh -c "/usr/bin/limine bios-install $disk && /usr/bin/cp /usr/share/limine/limine-bios.sys /boot/limine/"'
EOF
fi

#manual editing if required
nano scripts/variables.sh
source scripts/variables.sh
