# 04 - Configuración y personalización

Esta sección final aplica la personalización visual y funcional del entorno.

## 1. Configuración del *shell* (Zsh)

### Instalación de Oh My Zsh
```bash
# Cambiar shell a zsh
chsh -s /usr/bin/zsh

# Instalar Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Tema Powerlevel10k
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
```
Ejecuta `p10k configure` después de reiniciar el *shell*.

### *Plugins*
Instalar *plugins* de autosugerencias y resaltado:
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

Editar `~/.zshrc`:
```bash
plugins=(git zsh-autosuggestions zsh-syntax-highlighting sudo z colored-man-pages command-not-found)
```

## 2. Configuración de i3 Window Manager

Editar `~/.config/i3/config`:

### Desactivar bloqueo de pantalla automático

Por defecto, i3 incluye `xss-lock` que activa `i3lock` tras inactividad. En un entorno *headless* accedido por RDP, esto causa problemas de reconexión. Para desactivarlo, comentar la línea:

```bash
# exec --no-startup-id xss-lock --transfer-sleep-lock -- i3lock --nofork
```

Aplicar el cambio sin reiniciar:

```bash
pkill xss-lock; i3-msg reload
```

### Configuración general

1.  **Habilitar i3blocks:**
    reemplazar `status_command i3status` por `status_command i3blocks`.
2.  **Configurar *gaps* y bordes:**
    ```
    gaps inner 8
    smart_gaps off
    default_border pixel 1
    ```
    **Nota:** `smart_gaps off` mantiene los gaps visibles incluso con ventanas maximizadas.
3.  **Tema Dracula y fuentes:**
    asegúrate de definir la fuente: `font pango:AdwaitaMono Nerd Font 9`.
    (Para los colores completos, ver documentación del tema Dracula para i3).

## 3. Configuración de la barra (i3blocks)

Crear `~/.config/i3blocks/config`. Este archivo define los *widgets* de la barra superior.

```bash
mkdir -p ~/.config/i3blocks
cat > ~/.config/i3blocks/config << 'EOF'
# Configuración simplificada de ejemplo
[time]
command=date "+%Y-%m-%d %H:%M:%S"
interval=1

[ip_local]
command=hostname -I | awk '{print "Local: " $1}'
interval=60

[user]
command=echo "User: $USER"
interval=once

[disconnect]
full_text=🛑 Disconnect
command=pkill -u $USER Xvnc
color=#FF6666
EOF
```
> **Nota:** puedes expandir esta configuración con íconos de Nerd Fonts como se detalla en guías avanzadas.

## 4. Configuración de terminal (xfce4-terminal)

Aplicar colores Dracula y fuente Nerd Font:

```bash
mkdir -p ~/.config/xfce4/terminal
# Configuración básica, se recomienda usar xfconf-query para aplicar
xfconf-query -c xfce4-terminal -p /font-name -s "AdwaitaMono Nerd Font 10"
xfconf-query -c xfce4-terminal -p /color-background -s "#282a36"
xfconf-query -c xfce4-terminal -p /color-foreground -s "#f8f8f2"
```

## 5. IDE Antigravity

Instalación del entorno de desarrollo:

```bash
sudo tee /etc/yum.repos.d/antigravity.repo << EOL
[antigravity-rpm]
name=Antigravity RPM Repository
baseurl=https://us-central1-yum.pkg.dev/projects/antigravity-auto-updater-dev/antigravity-rpm
enabled=1
gpgcheck=0
EOL

sudo dnf makecache && sudo dnf install antigravity
```

**Configuración (`settings.json`):**
```json
{
    "workbench.colorTheme": "Dracula Theme Soft",
    "terminal.integrated.fontFamily": "'AdwaitaMono Nerd Font'",
    "terminal.integrated.fontSize": 13
}
```

## Verificación final

Reinicia la sesión o recarga i3 (`Mod+Shift+R`) para ver todos los cambios aplicados.
