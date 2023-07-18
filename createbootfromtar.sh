#!/bin/bash


tar_file=$1
img_file=$2
loop=$3

IMG_SIZE=$(expr 1024 \* 1024 \* 1024)
dd if=/dev/zero of=$img_file bs=${IMG_SIZE} count=1
sfdisk $img_file <<EOF
label: dos
label-id: 0x5d8b75fc
device: new.img
unit: sectors

linux.img1 : start=2048, size=2095104, type=83, bootable
EOF

OFFSET=$(expr 512 \* 2048)
losetup -o ${OFFSET} $loop $img_file
mkfs.ext3 $loop
mkdir -p /os/mnt
mount -t auto $loop /os/mnt/
tar -xvf $tar_file -C /os/mnt/

mkdir -p /os/mnt/boot
extlinux --install /os/mnt/boot/
cat > /os/mnt/boot/syslinux.cfg <<EOF
DEFAULT linux
  SAY Now booting the kernel from SYSLINUX...
 LABEL linux
  KERNEL /vmlinuz
  APPEND ro root=/dev/sda1 initrd=/initrd.img
EOF
dd if=/usr/lib/syslinux/mbr/mbr.bin of=$img_file bs=440 count=1 conv=notrunc
umount /os/mnt
losetup -D
