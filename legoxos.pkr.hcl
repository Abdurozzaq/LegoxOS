packer {
  required_plugins {}
}

source "null" "legoxos" {
  communicator = "none"
}

build {
  sources = ["source.null.legoxos"]

  provisioner "shell-local" {
    inline = [
      "#!/bin/bash",
      "set -e",
      "",
      "echo '==> Mounting system directories...'",
      "mount --bind /dev build/rootfs/dev",
      "mount --bind /run build/rootfs/run",
      "mount -t proc none build/rootfs/proc",
      "mount -t sysfs none build/rootfs/sys",
      "",
      "# Trap function untuk memastikan unmount SELALU BERJALAN meskipun script error",
      "cleanup() {",
      "  echo '==> Cleaning up and unmounting...'",
      "  rm -rf build/rootfs/tmp/packer-scripts || true",
      "  echo '' > build/rootfs/etc/resolv.conf || true",
      "  umount build/rootfs/sys || true",
      "  umount build/rootfs/proc || true",
      "  umount build/rootfs/run || true",
      "  umount build/rootfs/dev || true",
      "}",
      "trap cleanup EXIT",
      "",
      "echo '==> Setting up resolv.conf...'",
      "echo 'nameserver 8.8.8.8' > build/rootfs/etc/resolv.conf",
      "",
      "echo '==> Running apt-get update...'",
      "chroot build/rootfs apt-get update",
      "",
      "echo '==> Copying scripts to chroot...'",
      "mkdir -p build/rootfs/tmp/packer-scripts",
      "cp scripts/01-base-packages.sh build/rootfs/tmp/packer-scripts/",
      "cp scripts/02-dev-tools.sh build/rootfs/tmp/packer-scripts/",
      "cp scripts/03-optimasi.sh build/rootfs/tmp/packer-scripts/",
      "cp scripts/04-ui-theme.sh build/rootfs/tmp/packer-scripts/",
      "cp scripts/05-installer.sh build/rootfs/tmp/packer-scripts/",
      "",
      "echo '==> Copying assets to chroot...'",
      "mkdir -p build/rootfs/usr/share/backgrounds",
      "mkdir -p build/rootfs/usr/share/pixmaps",
      "cp assets/wallpaper.png build/rootfs/usr/share/backgrounds/legoxos-wallpaper.png",
      "cp assets/logo.png build/rootfs/usr/share/pixmaps/legoxos-logo.png",
      "cp assets/legoxos-ascii.txt build/rootfs/usr/share/pixmaps/legoxos-ascii.txt",
      "mkdir -p build/rootfs/usr/share/legoxos-docs",
      "cp -r resources/docs/* build/rootfs/usr/share/legoxos-docs/ || true",
      "",
      "echo '==> Running provisioning scripts in chroot...'",
      "chroot build/rootfs env DEBIAN_FRONTEND=noninteractive /bin/bash /tmp/packer-scripts/01-base-packages.sh",
      "chroot build/rootfs env DEBIAN_FRONTEND=noninteractive /bin/bash /tmp/packer-scripts/02-dev-tools.sh",
      "chroot build/rootfs env DEBIAN_FRONTEND=noninteractive /bin/bash /tmp/packer-scripts/03-optimasi.sh",
      "chroot build/rootfs env DEBIAN_FRONTEND=noninteractive /bin/bash /tmp/packer-scripts/04-ui-theme.sh",
      "chroot build/rootfs env DEBIAN_FRONTEND=noninteractive /bin/bash /tmp/packer-scripts/05-installer.sh",
      "",

    ]
  }
}
