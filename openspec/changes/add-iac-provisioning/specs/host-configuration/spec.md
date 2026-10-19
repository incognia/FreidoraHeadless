## Purpose

Configura de forma automatizada e idempotente un host Fedora, bare metal o VM, hasta dejarlo equivalente a lo que describen las guías 01–06, usando `config/` como fuente de verdad.

## ADDED Requirements

### Requirement: Un playbook para ambos destinos
El repositorio SHALL incluir un *playbook* de Ansible que configure tanto `tsibi` (bare metal, x86_64) como la VM (aarch64), seleccionando el destino solo por inventario.

#### Scenario: VM recién creada
- **WHEN** se ejecuta el *playbook* con el inventario de la VM justo después de `terraform apply`
- **THEN** termina sin errores y la VM acepta sesiones RDP con i3, tema Dracula y las herramientas de desarrollo

#### Scenario: Bare metal
- **WHEN** se ejecuta el *playbook* con el inventario de bare metal
- **THEN** se aplica la misma configuración a `tsibi`, más los pasos exclusivos de bare metal

### Requirement: Idempotencia
El *playbook* MUST ser idempotente: una segunda ejecución sobre un host ya configurado no SHALL reportar cambios.

#### Scenario: Segunda ejecución
- **WHEN** se ejecuta el *playbook* dos veces seguidas sobre el mismo host
- **THEN** la segunda ejecución reporta `changed=0`

### Requirement: Modo de verificación
El *playbook* SHALL soportar `--check --diff` sin fallar, para revisar cambios antes de aplicarlos a `tsibi`.

#### Scenario: Revisión previa
- **WHEN** se ejecuta con `--check --diff` contra `tsibi`
- **THEN** muestra las diferencias previstas y no modifica el host

### Requirement: Diferencias por destino
La configuración específica de bare metal (IP estática, *hostname* real, enmascarado de suspensión) MUST aplicarse solo al bare metal, y la VM MUST conservar la red que le asigna el hipervisor.

#### Scenario: Red de la VM
- **WHEN** se configura la VM
- **THEN** no se aplica IP estática y la VM sigue siendo accesible por los puertos reenviados

### Requirement: Fuente de verdad única
Los *dotfiles* y archivos de sistema que despliega Ansible SHALL tomarse de `config/`, sin copias duplicadas dentro de `infra/`.

#### Scenario: Cambio de dotfile
- **WHEN** se modifica `config/dotfiles/.config/i3/config` y se vuelve a ejecutar el *playbook*
- **THEN** el cambio llega al host y es la única tarea reportada como modificada

### Requirement: Arquitecturas soportadas
El *playbook* SHALL funcionar en x86_64 y aarch64, y MUST fallar con un mensaje claro si un paquete no existe para la arquitectura del host.

#### Scenario: Paquete no disponible
- **WHEN** un paquete requerido no existe para la arquitectura del host
- **THEN** la ejecución se detiene indicando el paquete y la arquitectura

### Requirement: Datos sensibles fuera de Git
Los inventarios con IPs, dominios o usuarios reales MUST NOT versionarse; el repositorio SHALL incluir solo inventarios de ejemplo.

#### Scenario: Inventario real
- **WHEN** el usuario crea su inventario a partir del ejemplo
- **THEN** `git status` no lo muestra como archivo nuevo
