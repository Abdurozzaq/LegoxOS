#!/bin/bash
set -e

echo "=== [2/4] Menginstal Dev Tools & Multi-Environment ==="

export DEBIAN_FRONTEND=noninteractive
export HOME=/root

# 1. Web Dev Environment: Node.js (FNM, PNPM, YARN)
echo "=> Menginstal Web Dev Environment (Node.js via FNM)"
apt-get install -y nodejs npm unzip
npm install -g pnpm yarn

# Install FNM (Fast Node Manager) secara global
wget https://github.com/Schniz/fnm/releases/latest/download/fnm-linux.zip -O /tmp/fnm-linux.zip
unzip /tmp/fnm-linux.zip -d /usr/local/bin/
chmod +x /usr/local/bin/fnm
rm -f /tmp/fnm-linux.zip

# 2. Multi Python (PyEnv)
echo "=> Menginstal PyEnv dependencies"
apt-get install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python3-openssl git

echo "=> Script PyEnv disiapkan untuk user profile"
cat << 'EOF' >> /etc/skel/.bashrc
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
EOF
# Note: Pyenv installer will be run per-user or can be pre-cloned into /etc/skel/.pyenv
git clone https://github.com/pyenv/pyenv.git /etc/skel/.pyenv

# 3. Multi Go (GVM)
echo "=> Menginstal GVM dependencies"
apt-get install -y bison
cat << 'EOF' >> /etc/skel/.bashrc
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
EOF
# GVM installer must be run per-user, we will pre-download it for snap-post-install or run it here for skeleton.

# 4. Multi PHP
echo "=> Menginstal Multi PHP via Sury PPA (Testing/Trixie support may vary, fallback to Debian repo if needed)"
curl -sSL https://packages.sury.org/php/README.txt | bash -x || true
apt-get update
# Menginstal beberapa versi umum (8.1, 8.2, 8.3)
apt-get install -y php8.1 php8.2 php8.3 composer || echo "Sury PPA tidak tersedia untuk Trixie, mengabaikan..."



# 6. Hermes Agent CLI
echo "=> Menyiapkan placeholder untuk Hermes Agent CLI"
# Karena link spesifik tidak diberikan, kita asumsikan instalasi via npm (sebagai contoh) atau letakkan instruksi.
# apt-get install -y hermes-cli # contoh jika ada di repo

# 7. Rust-based Terminal Tools (eza, bat, fzf, lazydocker) & Starship
echo "=> Menginstal Terminal Tools Modern"
apt-get install -y bat fzf
# Install eza (modern ls)
wget -c https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz -O - | tar xz -C /usr/local/bin
# Install lazydocker
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
mv $HOME/.local/bin/lazydocker /usr/local/bin/ || true

echo "=> Menginstal Starship Prompt"
curl -sS https://starship.rs/install.sh | sh -s -- -y

# 8. Aplikasi Native GUI (Baked-in ISO)
echo "=> Menginstal Native GUI Apps (VSCode, DBeaver, Firefox, Chromium, Telegram, Discord, Postman, VLC, OnlyOffice)"

# Office Productivity (OnlyOffice)
echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections
wget -qO - https://download.onlyoffice.com/GPG-KEY-ONLYOFFICE | gpg --dearmor > /etc/apt/trusted.gpg.d/onlyoffice.gpg
echo "deb https://download.onlyoffice.com/repo/debian squeeze main" > /etc/apt/sources.list.d/onlyoffice.list
apt-get update
apt-get install -y onlyoffice-desktopeditors

# Multimedia & Codec (VLC, ffmpeg, Gstreamer)
apt-get install -y vlc ffmpeg gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav libavcodec-extra


# Firefox, Chromium & Telegram
apt-get install -y firefox-esr chromium telegram-desktop

# VSCode
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list
apt-get update
apt-get install -y code

# DBeaver
wget -O /usr/share/keyrings/dbeaver.gpg.key https://dbeaver.io/debs/dbeaver.gpg.key
echo "deb [signed-by=/usr/share/keyrings/dbeaver.gpg.key] https://dbeaver.io/debs/dbeaver-ce /" > /etc/apt/sources.list.d/dbeaver.list
apt-get update
apt-get install -y dbeaver-ce

# Discord
wget "https://discord.com/api/download?platform=linux&format=deb" -O discord.deb || true
apt-get install -y ./discord.deb || true
rm -f discord.deb

# Postman
wget "https://dl.pstmn.io/download/latest/linux64" -O postman.tar.gz || true
if [ -f postman.tar.gz ]; then
  tar -xzf postman.tar.gz -C /opt || true
  rm -f postman.tar.gz
  ln -sf /opt/Postman/Postman /usr/bin/postman || true
  cat <<EOF > /usr/share/applications/postman.desktop
[Desktop Entry]
Name=Postman
Exec=/opt/Postman/Postman
Icon=/opt/Postman/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOF
fi



# 9. LegoxOS Database Panel (Portainer Docker GUI)
echo "=> Mengonfigurasi LegoxOS Database Panel (Portainer)"
cat << 'EOF' > /usr/local/bin/legoxos-db-panel
#!/bin/bash
echo "Memeriksa Docker Daemon..."
if ! systemctl is-active --quiet docker; then
    echo "Docker belum berjalan. Memulai Docker..."
    sudo systemctl start docker
fi

echo "Mengecek apakah Portainer sudah berjalan..."
if ! sudo docker ps | grep -q portainer; then
    echo "Membuat volume dan menjalankan container Portainer..."
    sudo docker volume create portainer_data || true
    sudo docker run -d -p 9000:9000 -p 8000:8000 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
fi

echo "Membuka GUI LegoxOS Database Panel (Portainer)..."
xdg-open http://localhost:9000
EOF
chmod +x /usr/local/bin/legoxos-db-panel

cat << 'EOF' > /usr/share/applications/legoxos-db-panel.desktop
[Desktop Entry]
Name=LegoxOS DB Panel
Comment=Manajer Database Multi-Versi berbasis Docker (Portainer)
Exec=gnome-terminal -- bash -c "/usr/local/bin/legoxos-db-panel; sleep 2"
Icon=docker
Terminal=false
Type=Application
Categories=Development;Database;
EOF

echo "=== [2/4] Selesai ==="
