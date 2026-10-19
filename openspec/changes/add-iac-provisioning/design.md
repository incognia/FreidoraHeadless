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
├── macos/               # freidora.libvirtd.plist (LaunchAgent de libvirtd)
├── terraform/vm-macos/   # main.tf, variables.tf, outputs.tf, cloud-init.yaml, versions.tf
└── ansible/
    ├── ansible.cfg
    ├── site.yml
    ├── inventories/{baremetal,vm}/hosts.yml.example + group_vars/
    └── roles/{base,network,ssh,desktop,rdp,theme,shell,devtools}
```

### Hipervisor: QEMU + libvirt con el proveedor `dmacvicar/libvirt`
Es el proveedor libre más maduro y el mismo *stack* que se usaría en un host Linux. Se usa `qemu:///session` con un `libvirtd` de sesión persistente del usuario, gestionado por el LaunchAgent `infra/macos/freidora.libvirtd.plist` (`RunAtLoad` y `KeepAlive`; ver «Resultados de la prueba técnica») y el tipo de dominio `hvf`. Alternativas descartadas: Tart (proveedor inmaduro), UTM (sin proveedor) y VMware Fusion (proveedores sin mantenimiento).

**Versión fijada** del proveedor en `versions.tf`: `~> 0.9.9`. La serie 0.9 cambió el esquema respecto a 0.8 y ahora refleja el XML de libvirt.

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
- La arquitectura se toma de `ansible_facts['architecture']`. Los paquetes que dependen de la arquitectura se validan antes de instalarlos.

### Contraseña para RDP
xrdp autentica por PAM con la contraseña de la cuenta, y la VM se crea sin contraseña. El rol `rdp` aplica `freidora_user_password_hash` con el módulo `user`, solo si la variable está definida y con `no_log`. El *hash* SHA-512 se genera en el Mac con `openssl passwd -6`, así que no hace falta `passlib`, y vive en el `hosts.yml` que Git ignora. Alternativa descartada: un `passwd` manual, porque no es reproducible.

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

## Resultados de la prueba técnica (2026-10-19)

Probado en un Mac mini M4 con macOS 26.7.1, libvirt 12.8.0, QEMU 11.1.2, Terraform 1.16.6 y el proveedor 0.9.9.

**Paquetes aarch64 (tarea 2.3).** Disponibles en Fedora 44 aarch64: `ghostty` 1.3.1 (COPR `scottames/ghostty`), `code-insiders` 1.143 (repositorio de Microsoft) y `xrdp` 0.10.6. El rol `devtools` no necesita alternativas por arquitectura.

**Escenarios de `vm-provisioning` (tarea 2.4).** Se cumplen todos:
- La autenticación por contraseña se rechaza (`Permission denied (publickey,…)`).
- QEMU escucha solo en `127.0.0.1:2222` y `127.0.0.1:13389`. La IP LAN del Mac no responde en esos puertos.
- `terraform plan` sobre la VM ya creada no muestra cambios.
- `terraform destroy` elimina el dominio, los volúmenes, el *pool* y su directorio. `terraform apply` la vuelve a crear sin pasos manuales.

**Hallazgos que cambian la implementación:**
- **El demonio de libvirt.** `brew services start libvirt` lanza `libvirtd` con la configuración del sistema y no arranca como usuario normal. El demonio que levanta `virsh` por su cuenta (`virtqemud --timeout=120`) se apaga a los dos minutos y el proveedor no sabe arrancarlo. Hace falta un `libvirtd` de sesión persistente. Se resuelve con un LaunchAgent propio que lo arranca al iniciar sesión, lo relanza si se cae (verificado con `kill -9`) y le da un `PATH` con `/opt/homebrew/bin` para que encuentre `qemu-system-aarch64`.
- **La ruta del socket.** El proveedor busca `/run/user/<uid>/libvirt/libvirt-sock`, que es la ruta de Linux. En macOS el socket está en `~/.cache/libvirt/libvirt-sock`, así que se pasa en la URI con `?socket=`.
- **GICv3 obligatorio.** HVF no emula GICv2, que es el que libvirt elige por defecto. Se fija `features.gic.version = "3"`.
- **Dirección PCI de la red.** El `virtio-net-pci` que se añade por `qemu_commandline` choca con los *root ports* PCIe de libvirt en la ranura 1. Se le asigna `addr=0x1e` en `pcie.0`.
- **Reconexión desde `xrdp-sesrun`.** En xrdp 0.10.6 (aarch64), reconectar una sesión existente con `xrdp-sesrun` provoca un SEGV en `xrdp-sesman`, que no se reinicia solo. No afecta a las conexiones RDP normales probadas, pero si `sesman` cae hay que ejecutar `systemctl restart xrdp-sesman xrdp`.
- **Sesión Xorg por defecto.** El `xrdp.ini` de Fedora ofrece primero la sesión *Xorg*, que necesita `xorgxrdp` (no instalado); al elegirla, la conexión falla con «X server could not be started» (`errno 2` al ejecutar `/usr/libexec/Xorg`). Se versiona `config/system/xrdp.ini` con Xvnc como única sesión, para la VM y para bare metal.
- **Dominio huérfano.** Si el dominio se define pero falla al arrancar, el proveedor no lo registra en el estado y el siguiente `apply` falla con `domain already exists`. Se arregla con `virsh undefine <nombre> --nvram`. Va en la guía como problema conocido.

## Open Questions

- Recursos por defecto de la VM. Propuesta: 4 vCPU, 8 GiB de RAM y 40 GiB de disco. Se pueden ajustar sin cambiar el diseño.
