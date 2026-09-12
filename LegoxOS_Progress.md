# LegoxOS Development Progress

Dokumen ini digunakan untuk melacak progress pembuatan custom Linux distro LegoxOS.

## Fase 1: Perencanaan & Arsitektur
- [x] Menganalisa requirement dari `CustomLinuxDistroSpesification.txt`
- [x] Membuat Implementation Plan
- [ ] Menunggu persetujuan pengguna (User Approval)

## Fase 2: Konfigurasi Packer (Tukang Masak)
- [ ] Membuat file `legoxos.pkr.hcl`
- [ ] Membuat skrip instalasi paket dasar (Cinnamon, Docker, DB)
- [ ] Membuat skrip instalasi SDK & Tools (NVM, PyEnv, GVM, PHP)
- [ ] Membuat skrip optimasi service database
- [ ] Membuat skrip penyesuaian UI (Dark theme & Icon pack)

## Fase 3: Konfigurasi Post-Install
- [ ] Membuat skrip auto-install Snap (VSCode, Dbeaver, Android Studio, dll)
- [ ] Memasukkan skrip ke `/etc/skel`

## Fase 4: Wrapper Script (Tukang Bungkus)
- [ ] Membuat skrip `build-iso.sh`
- [ ] Setup `mksquashfs` configuration
- [ ] Setup `xorriso` configuration & GRUB bootloader template

## Fase 5: Build & Test
- [ ] Eksekusi Packer (membutuhkan lingkungan Linux/WSL)
- [ ] Eksekusi Wrapper Script
- [ ] Test boot ISO di Virtual Machine
