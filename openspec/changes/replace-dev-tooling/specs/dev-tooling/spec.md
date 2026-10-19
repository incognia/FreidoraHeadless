## Purpose

Define qué herramientas de desarrollo ofrece la estación *headless* (terminal, editor y asistente de IA), cómo se lanzan desde la sesión RDP y cómo se mantienen versionadas en el repositorio.

## ADDED Requirements

### Requirement: Terminal principal
El entorno SHALL usar Ghostty como terminal principal, con tema Dracula y AdwaitaMono Nerd Font. `xfce4-terminal` MUST permanecer instalado como respaldo.

#### Scenario: Abrir terminal con atajo
- **WHEN** el usuario presiona `Mod+Enter` en una sesión RDP
- **THEN** se abre una ventana de Ghostty con fondo `#282a36` y la fuente AdwaitaMono Nerd Font

#### Scenario: Ghostty no puede iniciar
- **WHEN** Ghostty falla al iniciar (por ejemplo, sin soporte OpenGL en la sesión)
- **THEN** el usuario puede abrir `xfce4-terminal` desde dmenu sin reinstalar nada

### Requirement: Editor de código
El entorno SHALL usar VS Code Insiders como IDE, instalado desde el repositorio oficial de Microsoft con verificación de firmas GPG activada.

#### Scenario: Instalación verificada
- **WHEN** se instala o actualiza `code-insiders` con dnf
- **THEN** el repositorio tiene `gpgcheck=1` y la llave de Microsoft importada, y dnf verifica la firma del paquete

### Requirement: Asistente de IA
El entorno SHALL usar Claude Code como asistente de IA, disponible como CLI en la terminal y como extensión dentro de VS Code Insiders, y MUST poder ejecutar los comandos `/opsx:*` de OpenSpec del repositorio.

#### Scenario: CLI disponible
- **WHEN** el usuario ejecuta `claude --version` en Ghostty
- **THEN** el comando responde con una versión instalada

#### Scenario: Comandos de OpenSpec
- **WHEN** el usuario abre Claude Code en la raíz del repositorio
- **THEN** los comandos `/opsx:propose`, `/opsx:apply` y `/opsx:archive` están disponibles

### Requirement: Lanzadores en la barra
La barra de i3blocks SHALL ofrecer lanzadores con clic para Ghostty y VS Code Insiders, y MUST NOT contener lanzadores de herramientas retiradas.

#### Scenario: Lanzar el IDE desde la barra
- **WHEN** el usuario hace clic en el bloque del IDE en la barra
- **THEN** se abre VS Code Insiders, desligado de i3blocks

### Requirement: Herramientas retiradas
El entorno MUST NOT tener instalados Warp Terminal ni Google Antigravity, ni el repositorio dnf de Antigravity.

#### Scenario: Verificación de retiro
- **WHEN** se ejecuta `rpm -q warp-terminal antigravity` y se lista `/etc/yum.repos.d/`
- **THEN** ninguno de los dos paquetes está instalado y no existe `antigravity.repo`

### Requirement: Configuración versionada
La configuración de Ghostty y el repositorio dnf de VS Code SHALL estar versionados en `config/` y MUST incluirse en `scripts/backup.sh` y `scripts/sync.sh`.

#### Scenario: Respaldo
- **WHEN** se ejecuta `scripts/backup.sh` en el host
- **THEN** `config/dotfiles/.config/ghostty/config` y `config/system/vscode.repo` reflejan el estado del host

#### Scenario: Restauración
- **WHEN** se ejecuta `scripts/sync.sh` en un host limpio
- **THEN** la configuración de Ghostty queda en `~/.config/ghostty/` y el repositorio de VS Code en `/etc/yum.repos.d/`
