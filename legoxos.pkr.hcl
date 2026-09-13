packer {
  required_plugins {

  }
}

source "chroot" "legoxos" {
  chroot_dir = "build/rootfs"
  # Menjalankan command wrapper untuk bind mount jika diperlukan
}

build {
  sources = ["source.chroot.legoxos"]

  # Mempersiapkan environment
  provisioner "shell" {
    inline = [
      "echo 'nameserver 8.8.8.8' > /etc/resolv.conf",
      "apt-get update"
    ]
  }

  provisioner "shell" {
    environment_vars = ["DEBIAN_FRONTEND=noninteractive"]
    scripts = [
      "scripts/01-base-packages.sh",
      "scripts/02-dev-tools.sh",
      "scripts/03-optimasi.sh",
      "scripts/04-ui-theme.sh"
    ]
  }

  # Membuat direktori autostart di skel
  provisioner "shell" {
    inline = [
      "mkdir -p /etc/skel/.config/autostart",
      "mkdir -p /etc/skel/.local/bin"
    ]
  }

  provisioner "file" {
    source      = "files/snap-post-install.sh"
    destination = "/etc/skel/.local/bin/snap-post-install.sh"
  }
  
  provisioner "file" {
    source      = "files/snap-post-install.desktop"
    destination = "/etc/skel/.config/autostart/snap-post-install.desktop"
  }

  # Memberikan hak akses eksekusi
  provisioner "shell" {
    inline = [
      "chmod +x /etc/skel/.local/bin/snap-post-install.sh",
      # Bersihkan resolv.conf sementara
      "echo '' > /etc/resolv.conf"
    ]
  }
}
