## 1. Documentación

- [x] 1.1 Agregar a `docs/02-Graphical_Env.md` la instalación de Ghostty (COPR) y su configuración Dracula; verificar que el bloque de `~/.config/ghostty/config` coincide con el de `config/`
- [x] 1.2 Reemplazar en `docs/04-Configuration.md` la sección «IDE Antigravity» por VS Code Insiders (repo con `gpgcheck=1`) y Claude Code (CLI + extensión); verificar con `grep -i antigravity docs/04-Configuration.md` sin resultados
- [x] 1.3 Actualizar `docs/05-Maintenance.md` (tabla resumen y comandos de actualización); verificar que no menciona Warp ni Antigravity
- [x] 1.4 Actualizar `README.md` (*badges*, herramientas, *stack*, sección SDD sin `.agents/`); conservar la historia de construcción como antecedente

## 2. Configuración versionada

- [x] 2.1 Crear `config/dotfiles/.config/ghostty/config` (tema Dracula, AdwaitaMono Nerd Font)
- [x] 2.2 Crear `config/system/vscode.repo` con `gpgcheck=1` y eliminar `config/system/antigravity.repo`
- [x] 2.3 En `config/dotfiles/.config/i3/config`, cambiar `Mod+Return` a `exec ghostty`
- [x] 2.4 En `config/dotfiles/.config/i3blocks/config`, reemplazar los lanzadores de Warp y Antigravity por Ghostty y VS Code Insiders; eliminar `config.bak`
- [x] 2.5 Actualizar `scripts/backup.sh` y `scripts/sync.sh` (ghostty y `vscode.repo` en lugar de `antigravity.repo`); verificar con `bash -n` en ambos

## 3. Integración OpenSpec

- [x] 3.1 Eliminar `.agents/` (comandos de Antigravity); verificar que `openspec validate --all` sigue pasando y `.claude/commands/opsx/` existe

## 4. Host tsibi (manual, en el servidor)

- [ ] 4.1 Instalar Ghostty, VS Code Insiders y Claude Code siguiendo las guías; verificar `ghostty --version`, `code-insiders --version`, `claude --version`
- [ ] 4.2 Aplicar a mano en el host solo los cambios de configuración de este cambio, sin usar `sync.sh` (`config/` sigue desfasado y lo sobrescribiría todo): `Mod+Return` → `exec ghostty` en `~/.config/i3/config`, lanzadores Ghostty y Code en `~/.config/i3blocks/config`, `~/.config/ghostty/config` y `export PATH="$HOME/.local/bin:$PATH"` en `~/.zshrc`; recargar i3 y verificar en la sesión RDP los escenarios del spec `dev-tooling` (atajo, lanzadores, `/opsx:*`)
- [ ] 4.3 Desinstalar `warp-terminal` y `antigravity` y borrar `/etc/yum.repos.d/antigravity.repo`; verificar con `rpm -q warp-terminal antigravity`
- [ ] 4.4 Ejecutar `scripts/backup.sh` en el host y revisar `git diff`: debe conservar los cambios de este cambio y traer el estado real del host; hacer commit

## 5. Cierre

- [x] 5.1 Registrar el cambio en `CHANGELOG.md`
