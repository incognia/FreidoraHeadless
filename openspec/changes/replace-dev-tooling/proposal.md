## Why

Con la adopción de SDD, el asistente principal es Claude Code (los comandos `/opsx:*` ya viven en `.claude/`). Warp y Antigravity duplican esa función con su propia IA, requieren cuentas y créditos aparte, y el repositorio de Antigravity se instala con `gpgcheck=0`. Conviene unificar el entorno en Claude Code + VS Code Insiders, con Ghostty como terminal.

## What Changes

- **BREAKING:** se retira Warp Terminal; Ghostty pasa a ser la terminal principal (`Mod+Enter` y lanzador en i3blocks). `xfce4-terminal` se conserva como respaldo.
- **BREAKING:** se retira Google Antigravity (paquete, repositorio `antigravity.repo` y lanzador); VS Code Insiders pasa a ser el IDE, instalado desde el repositorio oficial de Microsoft con verificación GPG.
- Se instala Claude Code (CLI con instalador nativo) y su extensión para VS Code Insiders.
- Se agrega configuración de Ghostty con tema Dracula y AdwaitaMono Nerd Font, versionada en `config/dotfiles/`.
- La integración de OpenSpec queda solo para Claude Code: se elimina `.agents/` (comandos para Antigravity).
- Se actualizan README, guías 02, 04 y 05, `backup.sh`, `sync.sh` y CHANGELOG.

## Capabilities

### New Capabilities
- `dev-tooling`: herramientas de desarrollo del entorno (terminal, editor, asistente de IA, lanzadores de la barra) y cómo se instalan, configuran, respaldan y restauran.

### Modified Capabilities
<!-- Ninguna: openspec/specs/ aún no tiene especificaciones. -->

## Impact

- **Host `tsibi`:** desinstalar `warp-terminal` y `antigravity`; eliminar `/etc/yum.repos.d/antigravity.repo`; instalar `ghostty` (COPR), `code-insiders` y Claude Code.
- **Repositorio:** `docs/02`, `docs/04`, `docs/05`, `README.md`, `config/dotfiles/.config/i3/config`, `config/dotfiles/.config/i3blocks/config`, nuevo `config/dotfiles/.config/ghostty/config`, nuevo `config/system/vscode.repo`, eliminar `config/system/antigravity.repo` y `.agents/`, `scripts/backup.sh`, `scripts/sync.sh`.
- **Dependencias nuevas:** COPR `scottames/ghostty`, repositorio `packages.microsoft.com/yumrepos/vscode`, instalador `claude.ai/install.sh`.
