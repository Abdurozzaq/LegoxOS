#!/bin/bash
set -e

echo "=== [3/4] Optimasi Service Database ==="

# Menonaktifkan auto-start untuk database agar RAM tidak membengkak saat booting
systemctl disable postgresql
systemctl disable mariadb
systemctl disable redis-server

# Menonaktifkan docker auto-start (opsional, tapi disarankan)
# systemctl disable docker

echo "=> Developer dapat menyalakannya secara manual (contoh: sudo systemctl start postgresql)"

echo "=== [3/4] Selesai ==="
