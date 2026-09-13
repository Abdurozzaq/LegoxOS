#!/bin/bash
set -e

echo "=== [2/4] Menginstal Dev Tools & Multi-Environment ==="

export DEBIAN_FRONTEND=noninteractive
export HOME=/root

# 1. Multi Node.js (NVM)
echo "=> Menginstal NVM"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
# Menambahkan ke skeleton profile agar setiap user baru dapat NVM
cat << 'EOF' >> /etc/skel/.bashrc
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOF

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

# 5. Android SDK & Platform Tools
echo "=> Menginstal Android SDK Base & Platform Tools"
apt-get install -y android-sdk adb fastboot

# 6. Hermes Agent CLI
echo "=> Menyiapkan placeholder untuk Hermes Agent CLI"
# Karena link spesifik tidak diberikan, kita asumsikan instalasi via npm (sebagai contoh) atau letakkan instruksi.
# apt-get install -y hermes-cli # contoh jika ada di repo

# 7. Starship Terminal Prompt
echo "=> Menginstal Starship Prompt"
curl -sS https://starship.rs/install.sh | sh -s -- -y

# 8. Aplikasi Native GUI (Baked-in ISO)
echo "=> Menginstal Native GUI Apps (VSCode, DBeaver, Firefox, Telegram, Discord, Postman, Android Studio, VLC, Spotify)"

# Multimedia & Codec (VLC, ffmpeg, Gstreamer)
apt-get install -y vlc ffmpeg gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav libavcodec-extra

# Spotify (Via Repositori Resmi)
curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" > /etc/apt/sources.list.d/spotify.list
apt-get update
apt-get install -y spotify-client

# Firefox & Telegram
apt-get install -y firefox-esr telegram-desktop

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

# Android Studio (Using direct link, fallback to skip if link expires)
wget "https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2024.1.1.12/android-studio-2024.1.1.12-linux.tar.gz" -O android-studio.tar.gz || true
if [ -f android-studio.tar.gz ]; then
  tar -xzf android-studio.tar.gz -C /opt || true
  rm -f android-studio.tar.gz
  ln -sf /opt/android-studio/bin/studio.sh /usr/bin/android-studio || true
  cat <<EOF > /usr/share/applications/android-studio.desktop
[Desktop Entry]
Name=Android Studio
Exec=/opt/android-studio/bin/studio.sh
Icon=/opt/android-studio/bin/studio.png
Terminal=false
Type=Application
Categories=Development;
EOF
fi

echo "=== [2/4] Selesai ==="
