#!/bin/bash
set -e

echo "=== [4/4] Konfigurasi UI Theme (Dark Mode & Xiaomi Icon) ==="

# Mengaktifkan Dark Mode di GTK / Cinnamon untuk user default (melalui skeleton)
mkdir -p /etc/skel/.config/gtk-3.0
cat <<EOF > /etc/skel/.config/gtk-3.0/settings.ini
[Settings]
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Papirus-Dark
gtk-application-prefer-dark-theme=1
EOF

# Install Papirus icon theme (sebagai alternatif Xiaomi Icon Theme jika tidak ada link spesifik)
apt-get install -y papirus-icon-theme

# Setting dconf untuk Cinnamon default (bisa menggunakan skrip init dconf)
mkdir -p /etc/dconf/profile
echo "user-db:user" > /etc/dconf/profile/user
echo "system-db:local" >> /etc/dconf/profile/user

mkdir -p /etc/dconf/db/local.d
cat <<EOF > /etc/dconf/db/local.d/00-legoxos-theme
[org/cinnamon/desktop/interface]
gtk-theme='Adwaita-dark'
icon-theme='Papirus-Dark'

[org/cinnamon/theme]
name='cinnamon-dark'
EOF

dconf update || true

echo "=== [4/4] Selesai ==="
