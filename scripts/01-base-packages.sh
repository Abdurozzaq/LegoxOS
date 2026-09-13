#!/bin/bash
set -e

echo "=== [1/4] Menginstal Paket Dasar, DE, & Database ==="

export DEBIAN_FRONTEND=noninteractive

# Menambahkan repository utama
cat <<EOF > /etc/apt/sources.list
deb http://deb.debian.org/debian trixie main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware
deb http://deb.debian.org/debian trixie-updates main contrib non-free non-free-firmware
EOF

apt-get update
apt-get upgrade -y

# Instalasi Software Dasar & Dukungan Jaringan
apt-get install -y sudo curl wget nano vim git jq htop net-tools software-properties-common dirmngr apt-transport-https ca-certificates

# Konfigurasi Locale untuk menghilangkan warning "Cannot set LC_CTYPE..."
sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen
locale-gen
update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Instalasi Desktop Environment (Cinnamon & X11)
apt-get install -y cinnamon dbus-x11 gnome-terminal xorg lightdm network-manager-gnome

# Instalasi Utilities (Screenshot, Clipboard History, Info, Installer, GUI Tools)
apt-get install -y flameshot diodon fastfetch calamares calamares-settings-debian

# Instalasi Git & Docker
apt-get install -y git docker.io docker-compose

# Instalasi Database (PostgreSQL, MariaDB, Redis)
apt-get install -y postgresql mariadb-server redis-server



echo "=== [1/4] Selesai ==="
