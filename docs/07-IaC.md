# 07 - Infraestructura como código (Terraform y Ansible)

Esta guía automatiza lo que describen las guías 01–06. Hay dos piezas independientes:

- **Terraform** (`infra/terraform/vm-macos/`) crea una VM Fedora 44 en un Mac con Apple Silicon. Es una alternativa a la instalación en bare metal, útil para probar cambios antes de aplicarlos al servidor.
- **Ansible** (`infra/ansible/`) configura cualquier host Fedora, sea bare metal o la VM, con el mismo *playbook*. Los *dotfiles* y archivos de sistema salen de `config/`, que es la única fuente de verdad.

La instalación en bare metal sigue siendo el camino principal. Las guías 01–06 se mantienen como referencia de lo que hace cada rol.

## 1. Requisitos en el Mac

Probado en un Mac mini M4 con macOS 26.

```bash
brew tap hashicorp/tap
brew install qemu libvirt hashicorp/tap/terraform ansible
```

> **No uses `brew services start libvirt`:** lanza el demonio del sistema, que no arranca como usuario normal.

### Demonio de libvirt (LaunchAgent)

Terraform necesita un `libvirtd` de sesión siempre disponible. El LaunchAgent del repositorio lo arranca al iniciar sesión y lo relanza si se cae:

```bash
cp infra/macos/freidora.libvirtd.plist ~/Library/LaunchAgents/
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/freidora.libvirtd.plist
```

**Verificación:**
```bash
launchctl print gui/$(id -u)/freidora.libvirtd | grep state
virsh -c "qemu:///session?socket=$HOME/.cache/libvirt/libvirt-sock" list --all
```

Para desinstalarlo: `launchctl bootout gui/$(id -u)/freidora.libvirtd`.

## 2. Ciclo de vida de la VM

```bash
cd infra/terraform/vm-macos
cp terraform.tfvars.example terraform.tfvars   # usuario y llave pública SSH
terraform init
terraform apply
```

La VM usa Fedora 44 Cloud aarch64 con aceleración HVF. Por defecto tiene 4 vCPU, 8 GiB de RAM y 40 GiB de disco, ajustables en `terraform.tfvars`. Los puertos solo escuchan en el *loopback* del Mac:

| Servicio | Dirección en el Mac |
| :--- | :--- |
| SSH | `127.0.0.1:2222` |
| RDP | `127.0.0.1:13389` |

**Comandos útiles:**
```bash
terraform output ssh_command     # cómo entrar por SSH
terraform plan                   # sin cambios si la VM está al día
terraform destroy                # elimina VM, discos y pool
```

### Problema conocido: dominio huérfano

Si la VM se define pero falla al arrancar, el proveedor no la registra en el estado y el siguiente `apply` falla con `domain already exists`. Para resolverlo:

```bash
virsh -c "qemu:///session?socket=$HOME/.cache/libvirt/libvirt-sock" undefine freidora-vm --nvram
terraform apply
```

## 3. Inventarios de Ansible

Los inventarios reales (`hosts.yml`) contienen IPs y usuarios, así que **Git los ignora**. Se versionan solo los ejemplos.

### VM

```bash
cd infra/terraform/vm-macos
terraform output -raw ansible_inventory > ../../ansible/inventories/vm/hosts.yml
```

xrdp autentica con la contraseña de la cuenta, y la VM se crea sin contraseña. Para poder entrar por RDP, añade al final de `hosts.yml` el *hash* de la contraseña que quieras usar:

```bash
openssl passwd -6     # pide la contraseña e imprime el hash
```

```yaml
      freidora_user_password_hash: "$6$..."
```

SSH sigue aceptando solo llaves. Volver a generar `hosts.yml` con `terraform output` borra esta línea, así que hay que añadirla de nuevo.

### Bare metal

```bash
cp infra/ansible/inventories/baremetal/hosts.yml.example infra/ansible/inventories/baremetal/hosts.yml
```

Rellena la IP, el usuario, la llave, el *hostname* y la red estática. No definas `freidora_user_password_hash`: así el *playbook* no toca la contraseña del servidor.

## 4. Ejecutar el *playbook*

```bash
cd infra/ansible

# VM (inventario por defecto en ansible.cfg)
ansible-playbook site.yml

# Bare metal: SIEMPRE revisar primero
ansible-playbook -i inventories/baremetal/hosts.yml site.yml --check --diff
ansible-playbook -i inventories/baremetal/hosts.yml site.yml
```

> **Antes de aplicar a bare metal:** ejecuta `scripts/backup.sh` en el servidor y haz commit. El *playbook* sobrescribe los *dotfiles* con los de `config/`, así que cualquier cambio local que no esté versionado se pierde.

Cada rol tiene una etiqueta, así que puedes ejecutar solo una parte, por ejemplo `--tags rdp`.

| Rol | Guía | Qué hace |
| :--- | :--- | :--- |
| `base` | 01 | Actualización, `multi-user.target`, suspensión enmascarada (solo bare metal) |
| `network` | 01 | *Hostname* e IP estática (solo bare metal) |
| `ssh` | 01 | `sshd` solo con llaves y sin `root` |
| `desktop` | 02, 03, 04 | i3, i3blocks, utilidades XFCE, dunst, Nerd Font, *wallpaper*, *dotfiles* |
| `rdp` | 03 | xrdp, Xvnc, *keymap*, `sesman.ini`, *firewall*, contraseña opcional |
| `theme` | 06 | Dracula GTK, iconos y Qt (descargas con *checksum*) |
| `shell` | 04 | Zsh, Oh My Zsh, Powerlevel10k y *plugins* (versiones fijadas) |
| `devtools` | 02, 04 | Ghostty, VS Code Insiders con extensiones, Claude Code |

El *playbook* es idempotente: una segunda ejecución debe terminar con `changed=0`.

### Problema conocido: `xrdp-sesman` caído

En xrdp 0.10.6 (aarch64), reconectar una sesión existente con `xrdp-sesrun` puede tumbar `xrdp-sesman`. Si RDP deja de responder:

```bash
sudo systemctl restart xrdp-sesman xrdp
```
