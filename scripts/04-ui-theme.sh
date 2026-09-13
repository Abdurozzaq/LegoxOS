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

# Setting gschema overrides (Cara paling ampuh untuk Cinnamon & GNOME)
mkdir -p /usr/share/glib-2.0/schemas/
cat <<EOF > /usr/share/glib-2.0/schemas/99_legoxos.gschema.override
[org.cinnamon.desktop.background]
picture-uri='file:///usr/share/backgrounds/legoxos-wallpaper.png'
picture-options='zoom'

[org.cinnamon.desktop.screensaver]
picture-uri='file:///usr/share/backgrounds/legoxos-wallpaper.png'

[org.cinnamon.desktop.interface]
gtk-theme='Adwaita-dark'
icon-theme='Papirus-Dark'

[org.cinnamon.theme]
name='cinnamon-dark'
EOF

# Compile schemas
glib-compile-schemas /usr/share/glib-2.0/schemas/

# Update Debian alternatives untuk wallpaper utama (berpengaruh ke semua DE & Login screen)
update-alternatives --install /usr/share/images/desktop-base/desktop-background desktop-background /usr/share/backgrounds/legoxos-wallpaper.png 100 || true
update-alternatives --set desktop-background /usr/share/backgrounds/legoxos-wallpaper.png || true

# PEMBASMIAN BRANDING DEBIAN SECARA BRUTAL (Login, Lockscreen, Fallback)
if [ -d /usr/share/desktop-base ]; then
    find /usr/share/desktop-base -type f \( -name "*.svg" -o -name "*.png" \) -exec sh -c 'cp /usr/share/backgrounds/legoxos-wallpaper.png "$1"' _ {} \; || true
fi
if [ -d /usr/share/images/desktop-base ]; then
    find /usr/share/images/desktop-base -type f \( -name "*.svg" -o -name "*.png" \) -exec sh -c 'cp /usr/share/backgrounds/legoxos-wallpaper.png "$1"' _ {} \; || true
fi

# Ganti ikon Start Menu Cinnamon bawaan Debian dengan logo LegoxOS
# Cinnamon menggunakan icon 'start-here' atau logo Debian
cp /usr/share/pixmaps/legoxos-logo.png /usr/share/cinnamon/theme/menu.svg || true
cp /usr/share/pixmaps/legoxos-logo.png /usr/share/cinnamon/theme/menu-symbolic.svg || true

# Ganti ikon start-here di tema Papirus
find /usr/share/icons/Papirus -name "start-here.svg" -exec sh -c 'cp /usr/share/pixmaps/legoxos-logo.png "$1"' _ {} \; || true
find /usr/share/icons/Papirus -name "debian-logo.svg" -exec sh -c 'cp /usr/share/pixmaps/legoxos-logo.png "$1"' _ {} \; || true

# Konfigurasi Identitas OS (OS Release)
cat <<EOF > /etc/os-release
PRETTY_NAME="LegoxOS 1.0 (Batik Edition)"
NAME="LegoxOS"
VERSION_ID="1.0"
VERSION="1.0 (Batik Edition)"
VERSION_CODENAME=trixie
ID=legoxos
ID_LIKE=debian
HOME_URL="https://legoxos.org/"
SUPPORT_URL="https://legoxos.org/support"
BUG_REPORT_URL="https://legoxos.org/bugs"
EOF

cat <<EOF > /etc/lsb-release
DISTRIB_ID=LegoxOS
DISTRIB_RELEASE=1.0
DISTRIB_CODENAME=batik
DISTRIB_DESCRIPTION="LegoxOS 1.0 (Batik Edition)"
EOF

echo "LegoxOS 1.0 \n \l" > /etc/issue
echo "LegoxOS 1.0" > /etc/issue.net

# Konfigurasi Fastfetch Custom (Menampilkan Network IP)
mkdir -p /etc/skel/.config/fastfetch
mkdir -p /root/.config/fastfetch

cat <<EOF > /etc/skel/.config/fastfetch/config.jsonc
{
  "\$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "source": "/usr/share/pixmaps/legoxos-ascii.txt",
    "color": {"1": "blue", "2": "green"}
  },
  "display": {
    "separator": " ➜  "
  },
  "modules": [
    "title",
    "separator",
    "os",
    "host",
    "kernel",
    "uptime",
    "packages",
    "shell",
    "terminal",
    "cpu",
    "gpu",
    "memory",
    "disk",
    "localip",
    "publicip",
    "break",
    "colors"
  ]
}
EOF

cp /etc/skel/.config/fastfetch/config.jsonc /root/.config/fastfetch/config.jsonc

# Tambahkan Fastfetch otomatis ketika buka terminal
echo "fastfetch" >> /etc/skel/.bashrc
echo "fastfetch" >> /root/.bashrc

# Aktifkan Starship Prompt
echo 'eval "\$(starship init bash)"' >> /etc/skel/.bashrc
echo 'eval "\$(starship init bash)"' >> /root/.bashrc

echo "=== [4/4] Selesai ==="
