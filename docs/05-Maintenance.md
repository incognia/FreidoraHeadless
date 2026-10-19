# 05 - Mantenimiento y referencia

Resumen del sistema configurado y comandos útiles para el mantenimiento diario.

## Resumen del sistema

| Componente | Configuración | Notas |
| :--- | :--- | :--- |
| **OS** | Fedora Linux (*Headless*) | Sin suspensión/hibernación |
| **Acceso** | RDP (xrdp), SSH | Puerto 3389, Llave Ed25519 |
| **WM** | i3 Window Manager | *Gaps* 16px, Bordes 1px |
| ***Shell*** | Zsh + Oh My Zsh | Powerlevel10k, Autosuggestions |
| **Terminal** | Ghostty | Nerd Fonts, Dracula Theme; xfce4-terminal de respaldo |
| **IDE** | VS Code Insiders | Extensiones Dracula y Claude Code |
| **Asistente IA** | Claude Code | CLI + extensión; comandos `/opsx:*` de OpenSpec |

## *Cheat sheet*

### Gestión de servicios
```bash
# Reiniciar RDP
sudo systemctl restart xrdp

# Ver estado de energía (deben estar masked)
systemctl status sleep.target suspend.target

# Verificar target del sistema (debe ser multi-user.target)
systemctl get-default

# Cambiar entre modos (si es necesario)
sudo systemctl set-default multi-user.target  # Sin interfaz gráfica local
sudo systemctl set-default graphical.target    # Con interfaz gráfica local
```

### Gestión de sesiones
```bash
# Matar sesiones RDP colgadas
pkill -u $USER Xvnc
```

### Wallpaper
```bash
# Recargar wallpaper (alias)
reloadbg

# Equivalente a
~/.fehbg
```

### Actualización
```bash
# Actualizar sistema
sudo dnf update -y

# Actualizar VS Code Insiders y Ghostty
sudo dnf update code-insiders ghostty

# Actualizar Claude Code (también se actualiza solo)
claude update
```

### Atajos de i3 (*default*)
- `Mod+Enter`: abrir terminal (Ghostty)
- `Mod+d`: abrir menú (dmenu/rofi)
- `Mod+Shift+q`: cerrar ventana
- `Mod+Shift+e`: salir de i3 (cierra sesión RDP)
- `Mod+Shift+r`: recargar configuración de i3

## Archivos clave
- `~/.xsession`: *script* de inicio RDP
- `~/.config/i3/config`: configuración de ventanas
- `~/.config/i3blocks/config`: configuración de barra
- `~/.zshrc`: configuración de *shell*
- `~/.config/ghostty/config`: configuración de la terminal
