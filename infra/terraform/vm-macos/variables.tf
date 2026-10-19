variable "vm_name" {
  description = "Libvirt domain name and guest hostname."
  type        = string
  default     = "freidora-vm"
}

variable "username" {
  description = "Guest user created by cloud-init, with passwordless sudo."
  type        = string
}

variable "ssh_public_key_path" {
  description = "Public key authorised for the guest user."
  type        = string
}

variable "vcpus" {
  description = "Virtual CPUs."
  type        = number
  default     = 4
}

variable "memory_mb" {
  description = "Guest memory in MiB."
  type        = number
  default     = 8192
}

variable "disk_gb" {
  description = "Size of the guest system disk in GiB."
  type        = number
  default     = 40
}

variable "ssh_port" {
  description = "Port on 127.0.0.1 forwarded to guest SSH (22)."
  type        = number
  default     = 2222
}

variable "rdp_port" {
  description = "Port on 127.0.0.1 forwarded to guest RDP (3389)."
  type        = number
  default     = 13389
}

variable "image_url" {
  description = "Fedora Cloud Base Generic aarch64 qcow2 image."
  type        = string
  default     = "https://dl.fedoraproject.org/pub/fedora/linux/releases/44/Cloud/aarch64/images/Fedora-Cloud-Base-Generic-44-1.7.aarch64.qcow2"
}

variable "pool_path" {
  description = "Directory for the libvirt storage pool holding the VM disks."
  type        = string
  default     = "~/.local/share/freidora/pool"
}
