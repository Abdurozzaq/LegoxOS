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
apt-get install -y papirus-icon-theme lightdm-gtk-greeter

# Konfigurasi LightDM Login Screen (Background Wallpaper & Logo)
mkdir -p /etc/lightdm
cat <<EOF > /etc/lightdm/lightdm-gtk-greeter.conf
[greeter]
background = /usr/share/backgrounds/legoxos-wallpaper.png
default-user-image = /usr/share/pixmaps/legoxos-logo.png
theme-name = Adwaita-dark
icon-theme-name = Papirus-Dark
EOF


# Setting dconf untuk Cinnamon default (bisa menggunakan skrip init dconf)
mkdir -p /etc/dconf/profile
echo "user-db:user" > /etc/dconf/profile/user
echo "system-db:local" >> /etc/dconf/profile/user

mkdir -p /etc/dconf/db/local.d
cat <<EOF > /etc/dconf/db/local.d/00-legoxos-theme
[org/cinnamon/desktop/interface]
gtk-theme='Adwaita-dark'
icon-theme='Papirus-Dark'

[org/cinnamon/desktop/background]
picture-uri='file:///usr/share/backgrounds/legoxos-wallpaper.png'
picture-options='zoom'

[org/cinnamon/desktop/screensaver]
picture-uri='file:///usr/share/backgrounds/legoxos-wallpaper.png'


[org/cinnamon/theme]
name='cinnamon-dark'
EOF

dconf update || true

echo "=== [4/4] Selesai ==="
