#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then
  echo "Harap jalankan sebagai root (sudo)"
  exit 1
fi

echo "=== Memulai Build LegoxOS ==="

mkdir -p build/rootfs
mkdir -p build/iso/live
mkdir -p build/iso/boot/grub

# 1. Debootstrap Debian 13 (Trixie)
echo "=== 1. Menarik Base System Debian 13 (Trixie) ==="
# Menggunakan debootstrap
debootstrap --arch=amd64 trixie build/rootfs http://deb.debian.org/debian/

# 2. Packer Provisioning
echo "=== 2. Packer Provisioning ==="
# Mount temporary filesystems
mount --bind /dev build/rootfs/dev
mount --bind /run build/rootfs/run
# Run packer
packer init legoxos.pkr.hcl
packer build legoxos.pkr.hcl
# Unmount
umount build/rootfs/run
umount build/rootfs/dev

# Bersihkan cache chroot
chroot build/rootfs apt-get clean

# 3. Mksquashfs
echo "=== 3. Membungkus RootFS ke Squashfs ==="
rm -f build/iso/live/filesystem.squashfs
mksquashfs build/rootfs build/iso/live/filesystem.squashfs -comp xz -e boot

# 4. Kernel dan Initrd
echo "=== 4. Menyiapkan Kernel & Initrd ==="
cp build/rootfs/boot/vmlinuz-* build/iso/live/vmlinuz
cp build/rootfs/boot/initrd.img-* build/iso/live/initrd

# 5. Konfigurasi GRUB
echo "=== 5. Menyiapkan Bootloader GRUB ==="
cat <<EOF > build/iso/boot/grub/grub.cfg
set default=0
set timeout=5

menuentry "Start LegoxOS Live" {
    linux /live/vmlinuz boot=live quiet splash
    initrd /live/initrd
}
EOF

# 6. Generate ISO
echo "=== 6. Generate ISO dengan Xorriso ==="
grub-mkrescue -o LegoxOS-Debian13-amd64.iso build/iso/

echo "=== Selesai! ISO tersedia: LegoxOS-Debian13-amd64.iso ==="
