#!/bin/bash
set -e

# File marker to ensure it only runs once
MARKER_FILE="$HOME/.config/snap_post_install_done"

if [ -f "$MARKER_FILE" ]; then
    exit 0
fi

# Ensure GUI is available (X11/Wayland)
if [ -z "$DISPLAY" ]; then
    # Fallback to CLI if no GUI
    echo "=== LegoxOS Post-Install ==="
    sudo snap install code --classic || true
    sudo snap install postman || true
    touch "$MARKER_FILE"
    exit 0
fi

# Define the list of applications to install
APPS=(
  "dbeaver-ce|DBeaver (Database GUI)|snap"
  "postman|Postman (API Testing)|snap"
  "code|Visual Studio Code|snap --classic"
  "android-studio|Android Studio|snap --classic"
  "firefox|Firefox Browser|snap"
  "telegram-desktop|Telegram Desktop|snap"
  "discord|Discord|snap"
)

TOTAL_APPS=${#APPS[@]}

(
for i in "${!APPS[@]}"; do
    IFS="|" read -r APP_CMD APP_NAME CMD_EXT <<< "${APPS[$i]}"
    
    # Hitung percentage
    PERCENT=$(( i * 100 / TOTAL_APPS ))
    
    # Update text and percentage for zenity
    echo "$PERCENT"
    echo "# Mengunduh dan menginstal $APP_NAME..."
    
    # Proses instalasi (silent)
    if ! sudo snap install $APP_CMD $CMD_EXT > /dev/null 2>&1; then
        echo "# Peringatan: Gagal menginstal $APP_NAME. Melanjutkan..."
        sleep 2
    fi
done

echo "100"
echo "# Instalasi selesai! Sistem Anda siap digunakan."
sleep 3
) | zenity --progress \
  --title="LegoxOS Auto-Installer" \
  --text="Menyiapkan Lingkungan Developer..." \
  --percentage=0 \
  --width=500 \
  --auto-close \
  --no-cancel \
  --window-icon=/usr/share/pixmaps/legoxos-logo.png

touch "$MARKER_FILE"
