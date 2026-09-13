#!/bin/bash
set -e

echo "=== [5/5] Mengonfigurasi Calamares Installer ==="

export DEBIAN_FRONTEND=noninteractive

# Ubah konfigurasi branding Calamares dari Debian ke LegoxOS
if [ -d /etc/calamares/branding/debian ]; then
    sed -i 's/projectName:         Debian/projectName:         LegoxOS/g' /etc/calamares/branding/debian/branding.desc
    sed -i 's/version:             13/version:             1.0 Batik Edition/g' /etc/calamares/branding/debian/branding.desc
    sed -i 's/shortVersion:        13/shortVersion:        1.0/g' /etc/calamares/branding/debian/branding.desc
    sed -i 's/versionedName:       Debian 13/versionedName:       LegoxOS 1.0/g' /etc/calamares/branding/debian/branding.desc
    sed -i 's/shortVersionedName:  Debian 13/shortVersionedName:  LegoxOS 1.0/g' /etc/calamares/branding/debian/branding.desc
    sed -i 's/bootloaderEntryName: Debian/bootloaderEntryName: LegoxOS/g' /etc/calamares/branding/debian/branding.desc
    
    # Hapus semua gambar debian yang ada di branding Calamares, ganti dengan wallpaper legoxos (sebagai welcome screen/slideshow)
    find /etc/calamares/branding/debian -name "*.png" -exec cp /usr/share/backgrounds/legoxos-wallpaper.png {} \; || true
    find /usr/share/calamares/branding/debian -name "*.png" -exec cp /usr/share/backgrounds/legoxos-wallpaper.png {} \; || true
    
    # Khusus untuk ikon dan logo, gunakan logo LegoxOS
    cp /usr/share/pixmaps/legoxos-logo.png /etc/calamares/branding/debian/logo.png || true
    cp /usr/share/pixmaps/legoxos-logo.png /etc/calamares/branding/debian/icon.png || true
    cp /usr/share/pixmaps/legoxos-logo.png /usr/share/calamares/branding/debian/logo.png || true
    cp /usr/share/pixmaps/legoxos-logo.png /usr/share/calamares/branding/debian/icon.png || true
fi

# Hapus shortcut bawaan "Install Debian" / Calamares murni agar live-config tidak meng-copy nya ke desktop
rm -f /usr/share/applications/install-debian.desktop || true
rm -f /usr/share/applications/debian-installer-launcher.desktop || true
rm -f /usr/share/applications/calamares.desktop || true
rm -f /etc/skel/Desktop/install-debian.desktop || true
rm -f /root/Desktop/install-debian.desktop || true

# Buat shortcut desktop untuk installer
mkdir -p /etc/skel/Desktop
cat <<EOF > /etc/skel/Desktop/install-legoxos.desktop
[Desktop Entry]
Type=Application
Version=1.0
Name=Install LegoxOS
Comment=Install this system permanently to your hard disk
Exec=sudo -E calamares
Icon=calamares
Terminal=false
Categories=System;
EOF

chmod +x /etc/skel/Desktop/install-legoxos.desktop

# Pastikan aplikasi instalasi muncul di Start Menu juga
cp /etc/skel/Desktop/install-legoxos.desktop /usr/share/applications/install-legoxos.desktop

echo "=== [5/5] Selesai ==="
