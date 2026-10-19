## Purpose

Permite crear en macOS (Apple Silicon), de forma declarativa y repetible, una VM Fedora equivalente a la estación bare metal, para usarla como entorno alternativo o de pruebas.

## ADDED Requirements

### Requirement: Creación declarativa de la VM
El repositorio SHALL permitir crear una VM Fedora 44 aarch64 en el Mac con un solo `terraform apply`, con aceleración por hardware y recursos (CPU, RAM, disco) configurables por variables.

#### Scenario: Creación desde cero
- **WHEN** el usuario ejecuta `terraform init && terraform apply` en `infra/terraform/vm-macos/` con las dependencias instaladas
- **THEN** se crea y arranca una VM Fedora 44 aarch64 acelerada con HVF, y Terraform muestra cómo conectarse por SSH y RDP

#### Scenario: Recursos personalizados
- **WHEN** el usuario define `vcpus = 6` y `memory_mb = 12288` en `terraform.tfvars`
- **THEN** la VM se crea con 6 vCPU y 12 GiB de RAM

### Requirement: Acceso inicial sin contraseña
La VM SHALL quedar accesible por SSH con la llave pública indicada por el usuario, sin contraseña, desde el primer arranque.

#### Scenario: Primer acceso
- **WHEN** termina `terraform apply`
- **THEN** `ssh -p <puerto> <usuario>@localhost` entra con la llave configurada y el usuario tiene `sudo`

#### Scenario: Contraseña deshabilitada
- **WHEN** se intenta entrar por SSH con contraseña
- **THEN** el acceso es rechazado

### Requirement: Acceso desde el host macOS
La VM SHALL exponer SSH y RDP en puertos de `localhost` del Mac, y MUST NOT exponerlos en otras interfaces de red.

#### Scenario: RDP local
- **WHEN** la VM ya fue configurada con Ansible y el usuario abre Microsoft Remote Desktop hacia `localhost:<puerto RDP>`
- **THEN** se abre la sesión i3

#### Scenario: Red externa
- **WHEN** otro equipo de la LAN intenta conectarse a los puertos reenviados del Mac
- **THEN** la conexión es rechazada

### Requirement: Ciclo de vida reproducible
La VM SHALL poder destruirse y recrearse sin pasos manuales y sin dejar recursos huérfanos en libvirt.

#### Scenario: Destrucción
- **WHEN** el usuario ejecuta `terraform destroy`
- **THEN** se eliminan el dominio, sus discos y el disco de cloud-init, y `virsh list --all` no muestra la VM

#### Scenario: Reaplicar sin cambios
- **WHEN** se ejecuta `terraform plan` sobre una VM ya creada sin cambiar variables
- **THEN** el plan no muestra cambios
