#!/bin/bash
set -e

echo "=== [4/4] Konfigurasi UI Theme (Dark Mode & Xiaomi Icon) ==="

# Mengaktifkan Dark Mode di GTK / Cinnamon untuk user default (melalui skeleton)
mkdir -p /etc/skel/.config/gtk-3.0
cat <<EOF > /etc/skel/.config/gtk-3.0/settings.ini
[Settings]
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Tela-dark
gtk-application-prefer-dark-theme=1
EOF

# Install Tema, ZSH, Plymouth, dan Nerd Fonts dependencies
apt-get install -y slick-greeter gtk3-nocsd zsh zsh-autosuggestions zsh-syntax-highlighting plymouth plymouth-themes unzip wget curl imagemagick fonts-ubuntu

# Install JetBrains Mono Nerd Font
echo "=> Menginstal JetBrains Mono Nerd Font"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip -O /tmp/JetBrainsMono.zip
mkdir -p /usr/share/fonts/JetBrainsMono
unzip -o /tmp/JetBrainsMono.zip -d /usr/share/fonts/JetBrainsMono
fc-cache -fv
rm -f /tmp/JetBrainsMono.zip
git clone https://github.com/vinceliuice/Tela-icon-theme.git /tmp/Tela-icon-theme
/tmp/Tela-icon-theme/install.sh -a -d /usr/share/icons
rm -rf /tmp/Tela-icon-theme

# Generate Text Logo "LegoxOS" menggunakan Ubuntu Bold
echo "=> Membuat logo teks dengan font Ubuntu Bold"
convert -background none -fill white -font /usr/share/fonts/truetype/ubuntu/Ubuntu-B.ttf -pointsize 64 label:"LegoxOS" /usr/share/pixmaps/legoxos-text-logo.png || true

# Konfigurasi LightDM Login Screen (menggunakan slick-greeter bawaan Cinnamon/Mint)
mkdir -p /etc/lightdm
cat <<EOF > /etc/lightdm/slick-greeter.conf
[Greeter]
background=/usr/share/backgrounds/legoxos-wallpaper.png
draw-user-backgrounds=false
logo=/usr/share/pixmaps/legoxos-text-logo.png
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
icon-theme='Tela-dark'

[org.cinnamon.theme]
name='cinnamon-dark'

[org.cinnamon.applets.menu]
custom-icon-name='/usr/share/pixmaps/legoxos-logo.png'
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

# Ganti ikon start-here di tema Tela
find /usr/share/icons/Tela* -name "start-here.svg" -exec sh -c 'cp /usr/share/pixmaps/legoxos-logo.png "$1"' _ {} \; || true
find /usr/share/icons/Tela* -name "debian-logo.svg" -exec sh -c 'cp /usr/share/pixmaps/legoxos-logo.png "$1"' _ {} \; || true

# Konfigurasi Identitas OS (OS Release)
cat <<EOF > /etc/os-release
PRETTY_NAME="LegoxOS 1.0 (Developer Edition)"
NAME="LegoxOS"
VERSION_ID="1.0"
VERSION="1.0"
VERSION_CODENAME=trixie 
ID=legoxos
ID_LIKE=debian 
HOME_URL="https://github.com/Abdurozzaq/LegoxOS"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"
EOF

cat <<EOF > /etc/lsb-release
DISTRIB_ID=LegoxOS
DISTRIB_RELEASE=1.0
DISTRIB_CODENAME=trixie
DISTRIB_DESCRIPTION="LegoxOS 1.0 (Developer Edition)"
EOF

echo "LegoxOS 1.0 \n \l" > /etc/issue
echo "LegoxOS 1.0 \n \l" > /etc/issue.net

# Konfigurasi Branding GRUB untuk OS yang sudah terinstal
if [ -f /etc/default/grub ]; then
    sed -i 's/^GRUB_DISTRIBUTOR=.*/GRUB_DISTRIBUTOR="LegoxOS"/g' /etc/default/grub
else
    echo 'GRUB_DISTRIBUTOR="LegoxOS"' >> /etc/default/grub
fi
update-grub || true

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

# Konfigurasi Plymouth (Animasi Booting)
echo "=> Mengonfigurasi Plymouth Boot Animation"
plymouth-set-default-theme -R spinner || true
# Timpa watermark spinner dengan logo Teks LegoxOS
cp /usr/share/pixmaps/legoxos-text-logo.png /usr/share/plymouth/themes/spinner/watermark.png || true
update-initramfs -u || true

# Konfigurasi ZSH sebagai Shell Default
echo "=> Mengonfigurasi ZSH"
# Ubah default shell untuk skeleton (user baru)
sed -i 's|SHELL=/bin/bash|SHELL=/bin/zsh|g' /etc/default/useradd
# Ubah default shell untuk root
chsh -s /bin/zsh root

cat << 'EOF' > /etc/skel/.zshrc
# Load ZSH Plugins
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Alias Modern
alias ls="eza --icons"
alias ll="eza --icons -l"
alias cat="batcat"

# Load Starship & Fastfetch
eval "$(starship init zsh)"
fastfetch

# Load FNM
eval "$(fnm env)"
EOF

# Copy ke root
cp /etc/skel/.zshrc /root/.zshrc

# Buat Desktop Shortcut untuk LegoxOS Documentation (GUI Docs)
echo "=> Membuat shortcut LegoxOS Documentation"
mkdir -p /etc/skel/Desktop
cat << 'EOF' > /etc/skel/Desktop/legoxos-docs.desktop
[Desktop Entry]
Name=Welcome to LegoxOS
Comment=LegoxOS Documentation & Guide
Exec=xdg-open /usr/share/legoxos-docs/index.html
Icon=help-browser
Terminal=false
Type=Application
Categories=System;Documentation;
EOF
chmod +x /etc/skel/Desktop/legoxos-docs.desktop
cp /etc/skel/Desktop/legoxos-docs.desktop /usr/share/applications/legoxos-docs.desktop

echo "=== [4/4] Selesai ==="
