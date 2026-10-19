locals {
  # QEMU user-mode networking: guest ports reachable only from the Mac's loopback.
  netdev = join(",", [
    "user,id=net0",
    "hostfwd=tcp:127.0.0.1:${var.ssh_port}-:22",
    "hostfwd=tcp:127.0.0.1:${var.rdp_port}-:3389",
  ])
}

resource "libvirt_pool" "freidora" {
  name = var.vm_name
  type = "dir"

  target = {
    path = pathexpand(var.pool_path)
  }

  create = {
    build     = true
    start     = true
    autostart = true
  }

  destroy = {
    delete = true
  }
}

# Read-only Fedora Cloud base image.
resource "libvirt_volume" "base" {
  name = "fedora-44-cloud-base.aarch64.qcow2"
  pool = libvirt_pool.freidora.name

  target = {
    format = { type = "qcow2" }
  }

  create = {
    content = { url = var.image_url }
  }
}

# Writable copy-on-write system disk.
resource "libvirt_volume" "system" {
  name          = "${var.vm_name}.qcow2"
  pool          = libvirt_pool.freidora.name
  capacity      = var.disk_gb
  capacity_unit = "GiB"

  target = {
    format = { type = "qcow2" }
  }

  backing_store = {
    path   = libvirt_volume.base.path
    format = { type = "qcow2" }
  }
}

resource "libvirt_cloudinit_disk" "seed" {
  name = "${var.vm_name}-cloudinit"

  user_data = templatefile("${path.module}/cloud-init.yaml", {
    hostname       = var.vm_name
    username       = var.username
    ssh_public_key = trimspace(file(pathexpand(var.ssh_public_key_path)))
  })

  meta_data = yamlencode({
    instance-id    = var.vm_name
    local-hostname = var.vm_name
  })
}

resource "libvirt_volume" "seed" {
  name = "${var.vm_name}-cloudinit.iso"
  pool = libvirt_pool.freidora.name

  create = {
    content = { url = libvirt_cloudinit_disk.seed.path }
  }
}

resource "libvirt_domain" "vm" {
  name        = var.vm_name
  type        = "hvf"
  vcpu        = var.vcpus
  memory      = var.memory_mb
  memory_unit = "MiB"
  running     = true

  os = {
    type         = "hvm"
    type_arch    = "aarch64"
    type_machine = "virt"
    firmware     = "efi"
  }

  cpu = {
    mode = "host-passthrough"
  }

  # HVF on Apple Silicon only emulates GICv3; libvirt defaults to v2.
  features = {
    acpi = true
    gic  = { version = "3" }
  }

  devices = {
    disks = [
      {
        source = {
          volume = {
            pool   = libvirt_volume.system.pool
            volume = libvirt_volume.system.name
          }
        }
        target = { dev = "vda", bus = "virtio" }
        driver = { type = "qcow2" }
      },
      {
        source = {
          volume = {
            pool   = libvirt_volume.seed.pool
            volume = libvirt_volume.seed.name
          }
        }
        target    = { dev = "vdb", bus = "virtio" }
        driver    = { type = "raw" }
        read_only = true
      },
    ]

    rngs = [
      {
        model   = "virtio"
        backend = { random = "/dev/urandom" }
      },
    ]
  }

  qemu_commandline = {
    args = [
      { value = "-netdev" },
      { value = local.netdev },
      { value = "-device" },
      # Fixed address so it does not clash with libvirt-managed PCIe root ports.
      { value = "virtio-net-pci,netdev=net0,bus=pcie.0,addr=0x1e" },
    ]
  }
}
