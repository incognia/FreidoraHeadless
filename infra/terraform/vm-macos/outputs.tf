output "ssh_command" {
  description = "SSH into the VM from the Mac."
  value       = "ssh -p ${var.ssh_port} ${var.username}@127.0.0.1"
}

output "rdp_address" {
  description = "RDP endpoint (after running the Ansible playbook)."
  value       = "127.0.0.1:${var.rdp_port}"
}

output "ansible_inventory" {
  description = "Ansible inventory for the VM; save as infra/ansible/inventories/vm/hosts.yml."
  value = yamlencode({
    vm = {
      hosts = {
        (var.vm_name) = {
          ansible_host                 = "127.0.0.1"
          ansible_port                 = var.ssh_port
          ansible_user                 = var.username
          ansible_ssh_private_key_file = trimsuffix(var.ssh_public_key_path, ".pub")
        }
      }
    }
  })
}
