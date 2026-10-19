## 1. Preparación del Mac

- [ ] 1.1 Instalar `qemu`, `libvirt`, `hashicorp/tap/terraform` y `ansible` con Homebrew e iniciar libvirt con `brew services start libvirt`; verificar con `virsh -c qemu:///session version` y `terraform version`
- [ ] 1.2 Agregar a `.gitignore` los inventarios reales, `*.tfstate*`, `.terraform/` y `terraform.tfvars`; verificar con `git check-ignore`

## 2. Spike: VM mínima

- [ ] 2.1 Crear `infra/terraform/vm-macos/` (versions.tf con proveedor fijado, variables, volumen base Fedora 44 Cloud aarch64, disco CoW, firmware UEFI, cloud-init); verificar que `terraform validate` pasa
- [ ] 2.2 Configurar la red de modo usuario con `hostfwd` en `127.0.0.1` para SSH y RDP; verificar `terraform apply` + `ssh -p 2222 <usuario>@localhost`
- [ ] 2.3 Comprobar desde la VM que existen paquetes aarch64 de `ghostty` (COPR) y `code-insiders`; registrar el resultado en design.md
- [ ] 2.4 Verificar los escenarios de `vm-provisioning`: contraseña rechazada, puertos no expuestos a la LAN, `terraform plan` sin cambios y `terraform destroy` sin restos en `virsh list --all`

## 3. Esqueleto de Ansible

- [ ] 3.1 Crear `infra/ansible/` con `ansible.cfg`, `site.yml`, `inventories/{baremetal,vm}/hosts.yml.example` y `group_vars`; verificar con `ansible-inventory --graph`
- [ ] 3.2 Agregar un *output* de Terraform con el bloque de inventario de la VM; verificar `ansible -i inventories/vm all -m ping`

## 4. Roles

- [ ] 4.1 Rol `base` (guía 01): actualización, `multi-user.target`, suspensión enmascarada solo en bare metal; verificar `systemctl get-default` en la VM
- [ ] 4.2 Rol `network` (guía 01 §3.5), solo para el grupo `baremetal`; verificar que no se ejecuta con el inventario de la VM
- [ ] 4.3 Rol `ssh` (guía 01 §4); verificar que la autenticación por contraseña sigue deshabilitada
- [ ] 4.4 Rol `desktop` (guía 02) con *dotfiles* desde `config/`; verificar que i3 y i3blocks quedan instalados
- [ ] 4.5 Rol `rdp` (guía 03) con `km-00000409.ini` y `sesman.ini` desde `config/system/`; verificar sesión RDP a `localhost:13389`
- [ ] 4.6 Rol `theme` (guía 06) con descargas de versión fijada y `checksum`; verificar el tema Dracula en GTK y Qt
- [ ] 4.7 Rol `shell` (guía 04) con clones `git` de versión fijada; verificar `zsh` con Powerlevel10k
- [ ] 4.8 Rol `devtools` (Ghostty, VS Code Insiders, Claude Code) con validación de arquitectura; verificar `ghostty --version`, `code-insiders --version`, `claude --version`

## 5. Verificación integral

- [ ] 5.1 Recrear la VM desde cero (`destroy` + `apply` + *playbook*) y verificar los escenarios de `host-configuration` en la VM
- [ ] 5.2 Ejecutar el *playbook* dos veces seguidas sobre la VM; verificar `changed=0` en la segunda

## 6. Bare metal (manual, en tsibi)

- [ ] 6.1 Ejecutar `scripts/backup.sh` en `tsibi` y hacer commit del estado real
- [ ] 6.2 Ejecutar el *playbook* contra `tsibi` con `--check --diff`; revisar que no hay diferencias inesperadas
- [ ] 6.3 Aplicar el *playbook* a `tsibi` y verificar sesión RDP y `changed=0` en una segunda ejecución

## 7. Documentación

- [ ] 7.1 Crear `docs/07-IaC.md` (requisitos del Mac, ciclo de vida de la VM, uso del *playbook* en ambos destinos, `--check --diff` obligatorio en bare metal)
- [ ] 7.2 Actualizar `README.md` (guía 07, VM como alternativa a bare metal, Terraform y Ansible en el *stack*) y `CHANGELOG.md`
