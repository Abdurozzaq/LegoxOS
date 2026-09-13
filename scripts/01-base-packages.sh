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

# Instalasi Kebutuhan Live CD
apt-get install -y live-boot live-config systemd-sysv linux-image-amd64 sudo nano curl wget gnupg2 ca-certificates

# Instalasi Desktop Environment (Cinnamon & X11)
apt-get install -y cinnamon dbus-x11 gnome-terminal xorg lightdm network-manager-gnome

# Instalasi Utilities (Screenshot, Clipboard History)
apt-get install -y flameshot diodon

# Instalasi Git & Docker
apt-get install -y git docker.io docker-compose

# Instalasi Database (PostgreSQL, MariaDB, Redis)
apt-get install -y postgresql mariadb-server redis-server

# Instalasi Snapd
apt-get install -y snapd

echo "=== [1/4] Selesai ==="
