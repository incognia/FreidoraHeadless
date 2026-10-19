## Context

- Cliente: Mac mini M4 (Apple Silicon), así que la VM es Fedora **aarch64**; `tsibi` es x86_64.
- La sesión gráfica usa xrdp + Xvnc, que no necesitan GPU; funciona igual en una VM.
- Ninguna de las herramientas (Terraform, Ansible, QEMU, libvirt) está instalada hoy en el Mac.
- Las guías 01–06 son la referencia funcional de lo que debe hacer Ansible. Ver proposal.md para la motivación.

## Goals / Non-Goals

**Goals:**
- Separación clara: Terraform solo crea la VM; Ansible configura cualquier host.
- Paridad funcional entre la VM y `tsibi` en todo lo que no dependa del hardware.

**Non-Goals:**
- Crear `tsibi` con Terraform (es bare metal).
- Retirar las guías manuales o `scripts/sync.sh` (cambio posterior).
- Soportar otros hipervisores u otros sistemas host (Linux, Intel Mac).
- Exponer la VM a la LAN o a Internet.

## Decisions

### Estructura

```
infra/
├── terraform/vm-macos/   # main.tf, variables.tf, outputs.tf, cloud-init.yaml, versions.tf
└── ansible/
    ├── ansible.cfg
    ├── site.yml
    ├── inventories/{baremetal,vm}/hosts.yml.example + group_vars/
    └── roles/{base,network,ssh,desktop,rdp,theme,shell,devtools}
```

### Hipervisor: QEMU + libvirt con el proveedor `dmacvicar/libvirt`
Es el proveedor libre más maduro y el mismo *stack* que se usaría en un host Linux. Se usa `qemu:///session` (libvirt como servicio de usuario con `brew services`) y el tipo de dominio `hvf`. Alternativas descartadas: Tart (proveedor inmaduro), UTM (sin proveedor) y VMware Fusion (proveedores sin mantenimiento).

**Versión fijada** del proveedor en `versions.tf`: la serie 0.9 cambió el esquema respecto a 0.8, así que la versión exacta se elige en la tarea de prueba técnica (*spike*) y se fija con `~>`.

### Red: modo usuario de QEMU con reenvío de puertos
En macOS libvirt no puede crear la red NAT `default` (no hay *bridges* de Linux). Se usa la red de modo usuario de QEMU con `hostfwd` hacia `127.0.0.1`: SSH `2222→22` y RDP `13389→3389`, configurables. Si el proveedor no la expone directamente, se inyecta con la transformación XSLT que admite el recurso de dominio. Atar el reenvío a `127.0.0.1` cumple el requisito de no exponer la VM a la LAN.

### Imagen y firmware
- Imagen: Fedora 44 Cloud Base Generic aarch64 (qcow2), descargada como volumen base de libvirt; el disco de la VM es una capa *copy-on-write* redimensionada a `disk_gb`.
- Firmware UEFI: `edk2-aarch64-code.fd` incluido con el QEMU de Homebrew. Su ruta se resuelve con una variable, con valor por defecto según `brew --prefix`.
- cloud-init (`libvirt_cloudinit_disk`): crea el usuario, instala la llave pública, da `sudo` sin contraseña y desactiva la autenticación SSH por contraseña.

Se usa la imagen Cloud en lugar del ISO de Server porque arranca sin instalador interactivo; Ansible añade lo que falte respecto a Server.

### Terraform y no OpenTofu
Se usa `hashicorp/tap/terraform`, como pidió el usuario. El código no usa nada exclusivo de Terraform, así que OpenTofu sirve como sustituto directo.

### Ansible: roles por guía y variables por destino
| Rol | Guía | Notas |
| :--- | :--- | :--- |
| `base` | 01 | Actualización, `multi-user.target`, suspensión enmascarada (solo bare metal) |
| `network` | 01 §3.5 | IP estática y *hostname*; **solo** en el grupo `baremetal` |
| `ssh` | 01 §4 | Llaves y endurecimiento de `sshd` |
| `desktop` | 02 | i3, i3blocks, utilidades XFCE, Nerd Font |
| `rdp` | 03 | xrdp, *keymap*, `sesman.ini`, *firewall* |
| `theme` | 06 | Dracula GTK/Qt/iconos (descargas con versión fijada) |
| `shell` | 04 | Zsh, Oh My Zsh, Powerlevel10k, *plugins* |
| `devtools` | 04 | Ghostty, VS Code Insiders, Claude Code (de `replace-dev-tooling`) |

- Los *dotfiles* se despliegan con `copy`/`template` apuntando a `{{ playbook_dir }}/../../config/` (requisito de fuente de verdad única).
- Las diferencias entre destinos van en `group_vars/{baremetal,vm}`. No se hacen ramificaciones por nombre de host.
- Las descargas (Nerd Fonts, Dracula) usan `get_url` con `checksum` para ser idempotentes y verificables.
- Los clones de git (Oh My Zsh, p10k, *plugins*) usan el módulo `git` con `version` fijada.
- La arquitectura se toma de `ansible_architecture`. Los paquetes que dependen de la arquitectura se validan antes de instalarlos.

### Inventarios
Se versionan solo los `hosts.yml.example`. `.gitignore` excluye `infra/ansible/inventories/*/hosts.yml`, `*.tfstate*`, `.terraform/` y `terraform.tfvars`. El inventario de la VM puede generarse a partir de los *outputs* de Terraform.

## Risks / Trade-offs

- **[libvirt en macOS es menos pulido que en Linux]** → Mitigación: una tarea de prueba técnica temprana crea una VM mínima antes de construir el resto. Si falla, se reabre la decisión del hipervisor (Tart es la alternativa).
- **[Red de modo usuario: sin ICMP y con menos rendimiento]** → Mitigación: es suficiente para SSH y RDP locales, y no se necesita más.
- **[Ghostty COPR o VS Code Insiders sin compilación aarch64]** → Mitigación: el requisito de arquitecturas obliga a fallar con un mensaje claro. Se verifica en la prueba técnica.
- **[Aplicar Ansible a `tsibi` puede pisar cambios manuales no versionados]** → Mitigación: ejecutar primero `scripts/backup.sh` y después `--check --diff`, que es obligatorio en la guía.
- **[El estado de Terraform es local]** → Mitigación: es aceptable para una VM personal y desechable. Queda fuera de Git.

## Migration Plan

1. Aplicar antes `replace-dev-tooling`.
2. Prueba técnica: VM mínima con Terraform y acceso SSH.
3. Construir los roles probándolos solo contra la VM hasta que sean idempotentes.
4. Ejecutar `backup.sh` en `tsibi`, y después el *playbook* con `--check --diff`; revisar y aplicar.

**Rollback:** `terraform destroy` elimina la VM. En `tsibi`, se restaura con `scripts/sync.sh` desde el commit previo.

## Open Questions

- Recursos por defecto de la VM. Propuesta: 4 vCPU, 8 GiB de RAM y 40 GiB de disco. Se pueden ajustar sin cambiar el diseño.
