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
    
    # Gunakan logo LegoxOS untuk installer
    if [ -f /usr/share/pixmaps/legoxos-logo.png ]; then
        cp /usr/share/pixmaps/legoxos-logo.png /etc/calamares/branding/debian/logo.png
    fi
fi

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
