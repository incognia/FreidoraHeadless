## Why

Hoy el entorno solo se reproduce siguiendo a mano las guías 01–06 sobre bare metal, y eso ya provocó que `config/` y la documentación quedaran desfasadas. Automatizar la configuración con Ansible y añadir una VM de Fedora creada con Terraform en el Mac permite reconstruir el entorno en minutos, probar cambios antes de aplicarlos a `tsibi` y validar los escenarios de las especificaciones de forma repetible.

## What Changes

- Nuevo directorio `infra/terraform/vm-macos/`: Terraform con el proveedor `dmacvicar/libvirt` crea en el Mac mini M4 una VM Fedora 44 aarch64 sobre QEMU (aceleración HVF), con cloud-init para el usuario y la llave SSH, y reenvío de puertos para SSH y RDP.
- Nuevo directorio `infra/ansible/`: un *playbook* con roles que traducen las guías 01–06 (base del sistema, red, SSH, entorno gráfico, RDP, tema Dracula, *shell* y herramientas de desarrollo) y se aplica tanto a `tsibi` (bare metal, x86_64) como a la VM (aarch64) mediante inventarios separados.
- Los *dotfiles* que despliega Ansible salen de `config/`, que pasa a ser la fuente de verdad única para ambos destinos.
- Nueva guía `docs/07-IaC.md` y actualización del README: la instalación bare metal sigue siendo el camino principal y documentado; la VM es una alternativa.
- Los inventarios reales (IPs, usuarios) quedan fuera de Git; se versionan solo ejemplos.

## Capabilities

### New Capabilities
- `vm-provisioning`: creación, acceso y destrucción de una VM Fedora en macOS con Terraform.
- `host-configuration`: configuración automatizada e idempotente de un host Fedora (bare metal o VM) con Ansible, equivalente a las guías 01–06.

### Modified Capabilities
<!-- Ninguna: openspec/specs/ aún no tiene especificaciones. -->

## Impact

- **Dependencias en el Mac:** Homebrew `qemu`, `libvirt`, `hashicorp/tap/terraform`, `ansible`.
- **Repositorio:** nuevos `infra/` y `docs/07-IaC.md`; cambios en `README.md`, `.gitignore` y `CHANGELOG.md`.
- **Relación con otros cambios:** el rol de herramientas de desarrollo instala Ghostty, VS Code Insiders y Claude Code, por lo que depende de `replace-dev-tooling`, que debe aplicarse primero.
- **`tsibi`:** Ansible se ejecuta contra el host real; la primera vez se hace en modo `--check --diff`.
- **`scripts/sync.sh`:** queda solapado con Ansible; se conserva por ahora y su retiro se decide en un cambio posterior.
