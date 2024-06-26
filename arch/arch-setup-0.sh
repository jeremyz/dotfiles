#! /usr/bin/env bash

DEV=/dev/sda
SWPF=/mnt/swapfile

function say()
{
   echo -e "\n$1 *************************************"
}

loadkeys fr_CH

say "EFIVARS"
modprobe -r efivars 2>/dev/null
umount /sys/firmware/efi/efivars 2>/dev/null
modprobe -r efivarfs 2>/dev/null
modprobe efivarfs
mount -t efivarfs efivarfs /sys/firmware/efi/efivars

VARS=$(efivar -l | wc -l)
echo "UEFI VARS : $VARS"
[ "$VARS" -eq 0 ] && exit 1

# http://www.rodsbooks.com/gdisk/sgdisk-walkthrough.html
# to retreive size info $ sgdisk -p $DEV
# N sectors * 512 / 1024 / 1024 / 1024 -> Gb
say "SGDISK : $DEV"
sgdisk -og $DEV || exit 1
sgdisk -n 1::+512M -c 1:efi -t 1:ef02 $DEV || exit 1
sgdisk -n 2::+100G -c 2:rootfs -t 2:8300 $DEV || exit 1
sgdisk -n 3:: -c 3:homefs -t 3:8300 $DEV || exit 1
#sgdisk -n 3:209979392:976773168 -c 3:homefs -t 3:8300 $DEV || exit 1
sgdisk -p $DEV || exit 1

say "MKFS : $DEV"
mkfs.fat -F32 ${DEV}1 || exit 1
mkfs.ext4 -L root ${DEV}2 || exit 1
mkfs.ext4 -L home ${DEV}3 || exit 1
parted $DEV set 1 bios_grub on

say "MOUNT : $DEV"
mount ${DEV}2 /mnt
mkdir /mnt/boot
mount ${DEV}1 /mnt/boot
mkdir /mnt/home
mount ${DEV}3 /mnt/home

say "SWAPFS : $SWPF"
dd if=/dev/zero of=$SWPF bs=1M count=1024 || exit 1
chmod 600 $SWPF || exit 1
mkswap $SWPF || exit 1
swapon $SWPF || exit 1

say "BASE SYSTEM"
pacman -Sy archlinux-keyring
echo "Server = http://mirror.puzzle.ch/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist
pacstrap /mnt base

say "ETC"
genfstab -U -p /mnt >> /mnt/etc/fstab
sed -i 's/\/mnt//' /mnt/etc/fstab
sed -i 's/\/mnt//' /etc/fstab
cp hostname locale.conf vconsole.conf /mnt/etc/
sed -i 's/#fr_CH/fr_CH/; s/#en_GB/en_GB/; s/#en_US/en_US/;' /mnt/etc/locale.gen
sed -i 's/^#\[multilib\]/[multilib]/; T; n; s/^#Include/Include/' /mnt/etc/pacman.conf

cp arch-setup-1.sh /mnt/ || exit 1

say " *** now launch ./arch-setup-1.sh !"
arch-chroot /mnt
