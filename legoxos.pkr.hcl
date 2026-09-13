packer {
  required_plugins {}
}

source "null" "legoxos" {
  communicator = "none"
}

build {
  sources = ["source.null.legoxos"]

  # Mempersiapkan environment (Mount & Copy file yang dibutuhkan)
  provisioner "shell-local" {
    inline = [
      "echo '==> Mounting system directories...'",
      "mount --bind /dev build/rootfs/dev",
      "mount --bind /run build/rootfs/run",
      "mount -t proc none build/rootfs/proc",
      "mount -t sysfs none build/rootfs/sys",
      
      "echo '==> Setting up resolv.conf...'",
      "echo 'nameserver 8.8.8.8' > build/rootfs/etc/resolv.conf",
      
      "echo '==> Running apt-get update...'",
      "chroot build/rootfs apt-get update",
      
      "echo '==> Copying scripts to chroot...'",
      "mkdir -p build/rootfs/tmp/packer-scripts",
      "cp scripts/01-base-packages.sh build/rootfs/tmp/packer-scripts/",
      "cp scripts/02-dev-tools.sh build/rootfs/tmp/packer-scripts/",
      "cp scripts/03-optimasi.sh build/rootfs/tmp/packer-scripts/",
      "cp scripts/04-ui-theme.sh build/rootfs/tmp/packer-scripts/"
    ]
  }

  # Menjalankan script instalasi dalam chroot
  provisioner "shell-local" {
    inline = [
      "echo '==> Running provisioning scripts in chroot...'",
      "chroot build/rootfs env DEBIAN_FRONTEND=noninteractive /bin/bash /tmp/packer-scripts/01-base-packages.sh",
      "chroot build/rootfs env DEBIAN_FRONTEND=noninteractive /bin/bash /tmp/packer-scripts/02-dev-tools.sh",
      "chroot build/rootfs env DEBIAN_FRONTEND=noninteractive /bin/bash /tmp/packer-scripts/03-optimasi.sh",
      "chroot build/rootfs env DEBIAN_FRONTEND=noninteractive /bin/bash /tmp/packer-scripts/04-ui-theme.sh"
    ]
  }

  # Menyalin dan mengatur file autostart
  provisioner "shell-local" {
    inline = [
      "echo '==> Setting up snap post-install scripts...'",
      "mkdir -p build/rootfs/etc/skel/.config/autostart",
      "mkdir -p build/rootfs/etc/skel/.local/bin",
      
      "cp files/snap-post-install.sh build/rootfs/etc/skel/.local/bin/snap-post-install.sh",
      "cp files/snap-post-install.desktop build/rootfs/etc/skel/.config/autostart/snap-post-install.desktop",
      
      "chmod +x build/rootfs/etc/skel/.local/bin/snap-post-install.sh"
    ]
  }

  # Cleanup & Unmount
  provisioner "shell-local" {
    inline = [
      "echo '==> Cleaning up...'",
      "rm -rf build/rootfs/tmp/packer-scripts",
      "echo '' > build/rootfs/etc/resolv.conf",
      
      "echo '==> Unmounting system directories...'",
      "umount build/rootfs/sys || true",
      "umount build/rootfs/proc || true",
      "umount build/rootfs/run || true",
      "umount build/rootfs/dev || true"
    ]
  }
}
