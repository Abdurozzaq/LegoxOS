#!/bin/bash
set -e

# File marker to ensure it only runs once
MARKER_FILE="$HOME/.config/snap_post_install_done"

if [ -f "$MARKER_FILE" ]; then
    exit 0
fi

# We use gnome-terminal or any installed terminal to run this interactively 
# so the user can see the progress on first boot.
# This script itself runs the actual installation.

echo "=== LegoxOS Post-Install: Menginstal Aplikasi Bawaan ==="
echo "Mohon tunggu, proses ini membutuhkan koneksi internet yang stabil."

sudo snap install dbeaver-ce
sudo snap install postman
sudo snap install code --classic
sudo snap install android-studio --classic
sudo snap install rustdesk --classic || echo "Rustdesk mungkin butuh .deb manual"
# Ungoogled Chromium & Firefox
sudo snap install firefox
# Ungoogled Chromium is usually not on snap, fallback to flatpak or manual if needed. Let's try snap or warn.
sudo snap install ungoogled-chromium || echo "Ungoogled Chromium tidak di temukan di snap, harap install via flatpak"

sudo snap install telegram-desktop
sudo snap install discord
sudo snap install tailscale || echo "Tailscale sebaiknya diinstall via repo apt"
sudo snap install bitwarden
sudo snap install wps-office || echo "WPS Office tidak ditemukan di snap, harap install via flatpak/deb"

echo "=== Instalasi Selesai ==="
touch "$MARKER_FILE"
read -p "Tekan Enter untuk menutup..."
