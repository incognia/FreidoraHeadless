# 05 - Mantenimiento y referencia

Resumen del sistema configurado y comandos útiles para el mantenimiento diario.

## Resumen del sistema

| Componente | Configuración | Notas |
| :--- | :--- | :--- |
| **OS** | Fedora Linux (*Headless*) | Sin suspensión/hibernación |
| **Acceso** | RDP (xrdp), SSH | Puerto 3389, Llave Ed25519 |
| **WM** | i3 Window Manager | *Gaps* 16px, Bordes 1px |
| ***Shell*** | Zsh + Oh My Zsh | Powerlevel10k, Autosuggestions |
| **Terminal** | xfce4-terminal | Nerd Fonts, Dracula Theme |
| **IDE** | Antigravity | Basado en VS Code |

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

### Actualización
```bash
# Actualizar sistema
sudo dnf update -y

# Actualizar Antigravity
sudo dnf update antigravity
```

### Atajos de i3 (*default*)
- `Mod+Enter`: abrir terminal
- `Mod+d`: abrir menú (dmenu/rofi)
- `Mod+Shift+q`: cerrar ventana
- `Mod+Shift+e`: salir de i3 (cierra sesión RDP)
- `Mod+Shift+r`: recargar configuración de i3

## Archivos clave
- `~/.xsession`: *script* de inicio RDP
- `~/.config/i3/config`: configuración de ventanas
- `~/.config/i3blocks/config`: configuración de barra
- `~/.zshrc`: configuración de *shell*
