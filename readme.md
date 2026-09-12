# LegoxOS Custom Linux Distro
**By Abdurozzaq**

Sebuah custom Linux Distro berbasis Debian 13, dirancang dan dikonfigurasi secara khusus menggunakan Packer untuk kebutuhan development. Berikut adalah rincian arsitektur dan panduan penggunaannya.

## Arsitektur & File Konfigurasi

### 1. Packer Configuration
- [`legoxos.pkr.hcl`](./legoxos.pkr.hcl): Konfigurasi Packer yang bertindak sebagai "Tukang Masak". Menggunakan plugin `chroot` untuk membangun OS secara langsung di dalam direktori `build/rootfs`.

### 2. Provisioning Scripts (Tukang Masak - Packer)
- [`scripts/01-base-packages.sh`](./scripts/01-base-packages.sh): Menginstal paket dasar Live CD, Cinnamon DE, Docker, Git, dan Database (PostgreSQL, MariaDB, Redis).
- [`scripts/02-dev-tools.sh`](./scripts/02-dev-tools.sh): Menyiapkan NVM, PyEnv, GVM, Multi PHP, Android SDK & Tools.
- [`scripts/03-optimasi.sh`](./scripts/03-optimasi.sh): Menonaktifkan auto-start database (Redis, Postgres, MariaDB) sesuai kebutuhan agar penggunaan RAM tidak boros.
- [`scripts/04-ui-theme.sh`](./scripts/04-ui-theme.sh): Menerapkan Dark Theme secara default dan Papirus/Xiaomi Icon Theme.

### 3. Post-Install Script (Aplikasi)
- [`files/snap-post-install.sh`](./files/snap-post-install.sh) & [`files/snap-post-install.desktop`](./files/snap-post-install.desktop): Script ini disuntikkan ke `/etc/skel` oleh Packer. Saat developer pertama kali booting atau membuat user baru, script ini akan otomatis berjalan di terminal dan mengunduh aplikasi utama via `snapd` (seperti DBeaver, Postman, VSCode, Android Studio, dll).

### 4. Wrapper Script (Tukang Bungkus)
- [`build-iso.sh`](./build-iso.sh): Script utama yang akan dijalankan untuk memulai proses build. Alur prosesnya:
  1. Menarik OS dasar Debian 13 menggunakan `debootstrap`.
  2. Menjalankan Packer untuk mengeksekusi skrip provisioning.
  3. Mengkompres hasil instalasi menjadi `filesystem.squashfs` menggunakan `mksquashfs`.
  4. Membuat bootable ISO final menggunakan `xorriso` (via `grub-mkrescue`).

---

## Langkah Selanjutnya (Cara Build)

> **⚠️ PERHATIAN: Lingkungan Build**
> Semua skrip yang berinteraksi dengan root file system (seperti `debootstrap`, `chroot`, `mksquashfs`) membutuhkan sistem **Linux Native**. Jika Anda menggunakan Windows, pastikan menggunakan **WSL2** dengan distro Debian/Ubuntu, atau menggunakan Virtual Machine Linux.

Untuk mulai mem-build ISO:

1. **Sinkronisasi File**
   Pindahkan atau sinkronisasikan direktori repository ini ke dalam environment Linux Anda.

2. **Instal Dependensi Host**
   Pastikan Anda telah menginstal beberapa tools berikut di sistem Linux Anda (Tuan Rumah):
   ```bash
   sudo apt update
   sudo apt install debootstrap packer squashfs-tools mtools xorriso grub-pc-bin grub-efi-amd64-bin
   ```

3. **Beri Hak Akses Eksekusi**
   Berikan izin akses eksekusi pada wrapper script:
   ```bash
   chmod +x build-iso.sh
   ```

4. **Jalankan Proses Build**
   Eksekusi script build (proses ini **harus** menggunakan `sudo`):
   ```bash
   sudo ./build-iso.sh
   ```

5. **Selesai!**
   Tunggu prosesnya selesai. Anda akan mendapatkan file **LegoxOS-Debian13-amd64.iso** di dalam direktori yang sama, siap untuk di-boot menggunakan VirtualBox atau Rufus.

> **💡 TIP:**
> Anda dapat meninjau file `LegoxOS_Progress.md` (jika ada) untuk melacak tahapan mana saja yang sudah diselesaikan dalam pengembangan.