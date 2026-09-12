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

echo "=== [2/4] Selesai ==="
