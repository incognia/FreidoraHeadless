terraform {
  required_version = ">= 1.9"

  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.9.9"
    }
  }
}

provider "libvirt" {
  # Per-user libvirtd session daemon. On macOS its socket lives in
  # ~/.cache/libvirt, not /run/user/<uid>, so it must be passed explicitly.
  uri = "qemu:///session?socket=${pathexpand("~/.cache/libvirt/libvirt-sock")}"
}
