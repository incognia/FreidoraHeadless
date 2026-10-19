## Context

La sesión gráfica corre sobre Xvnc (`xrandr --output VNC-0`), sin GPU expuesta: todo el renderizado es por software (Mesa llvmpipe). El host tiene i3 con `$mod = Mod1` y `bindsym $mod+Return exec i3-sensible-terminal`. Los lanzadores de la barra usan `setsid <app> >/dev/null 2>&1`. Ver proposal.md para la motivación.

## Goals / Non-Goals

**Goals:**
- Reemplazar Warp/Antigravity sin dejar restos (paquetes, repos, lanzadores, docs).
- Que cada pieza nueva sea reproducible con `sync.sh` + la guía.

**Non-Goals:**
- Sincronizar `settings.json` ni extensiones de VS Code (Settings Sync de VS Code lo cubre).
- Corregir el resto de los desfases de `config/` detectados en la revisión (cambio aparte).
- Configurar autenticación de Claude Code (es interactiva y personal).

## Decisions

- **Ghostty desde COPR `scottames/ghostty`.** Fedora no lo empaqueta en los repos oficiales; el COPR es el método que documenta Ghostty para Fedora. Alternativa: compilar con Zig (lento, sin actualizaciones automáticas).
- **`bindsym $mod+Return exec ghostty` explícito** en lugar de depender de `i3-sensible-terminal`/`$TERMINAL`. Es más predecible y no requiere variables de entorno en `.xsession`.
- **VS Code Insiders desde `packages.microsoft.com/yumrepos/vscode`** con `gpgcheck=1`. Es el mismo repo que `code` estable; el paquete es `code-insiders`. Alternativa: RPM descargado a mano (sin actualizaciones vía dnf).
- **Claude Code con el instalador nativo** (`curl -fsSL https://claude.ai/install.sh | bash`), que se autoactualiza y no depende de Node. Alternativa: `npm install -g` (requiere Node, desaconsejado por Anthropic).
- **Extensión de Claude Code** instalada con `code-insiders --install-extension anthropic.claude-code`.
- **Eliminar `.agents/`** en lugar de reinicializar OpenSpec: son archivos generados solo para Antigravity; `.claude/` queda intacto.
- **Tema de Ghostty:** `theme = Dracula` (incluido en Ghostty) y `font-family = AdwaitaMono Nerd Font`, alineado con i3, dunst y la guía 06.

## Risks / Trade-offs

- [Ghostty requiere OpenGL 3.3 y en Xvnc solo hay llvmpipe] → llvmpipe ofrece OpenGL 4.5, por lo que debería funcionar, pero con más CPU; se valida en el host y `xfce4-terminal` queda como respaldo (ver spec).
- [El COPR es de un tercero] → Es el método documentado por Ghostty; se acepta y se anota en la guía.
- [VS Code Insiders es una compilación diaria y puede romperse] → Se puede instalar `code` estable del mismo repo sin cambiar la configuración.
- [Desinstalar Antigravity elimina su configuración local] → Exportar lo que se quiera conservar antes de desinstalar.

## Migration Plan

1. En el host: instalar Ghostty, VS Code Insiders y Claude Code, y verificar que funcionan en la sesión RDP.
2. Cambiar el atajo de i3 y los lanzadores de i3blocks; recargar i3.
3. Desinstalar `warp-terminal` y `antigravity`; borrar `antigravity.repo`.
4. Ejecutar `backup.sh` y hacer commit.

**Rollback:** reinstalar los paquetes anteriores y restaurar `antigravity.repo` y la configuración de i3/i3blocks desde el commit previo.
