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
    gaps inner 16
    smart_gaps off
    default_border pixel 1
    ```
    **Nota:** `smart_gaps off` mantiene los gaps visibles incluso con ventanas maximizadas.
3.  **Tema Dracula y fuentes:**
    asegúrate de definir la fuente: `font pango:AdwaitaMono Nerd Font 9`.
    (Para los colores completos, ver documentación del tema Dracula para i3).

## 3. Configuración de la barra (i3blocks)

Crear `~/.config/i3blocks/config`. Este archivo define los bloques de la barra superior, con los colores de Dracula.

```bash
mkdir -p ~/.config/i3blocks
cat > ~/.config/i3blocks/config << 'EOF'
# i3blocks: Dracula status bar (FreidoraHeadless)
#
# Every block uses an inline command: Fedora's i3blocks package ships no
# blocklets in /usr/share/i3blocks.

separator_block_width=12
markup=pango

[ghostty]
full_text= Ghostty
command=setsid ghostty >/dev/null 2>&1
color=#50FA7B
separator=false

[vscode]
full_text= Code
command=setsid code-insiders >/dev/null 2>&1
color=#50FA7B

[public-ip]
label= 
command=curl -4 -s ifconfig.me
color=#6272A4
interval=once
separator=false

[ip_local]
label= 
command=hostname -I | awk '{print $1}'
color=#6272A4
interval=60

[cpu_usage]
label= 
command=top -bn1 | awk '/^%Cpu/ {printf "%.0f%%\n", 100 - $8}'
color=#F1FA8C
interval=10
separator=false

[load_average]
label= 
command=cut -d' ' -f1 /proc/loadavg
color=#F1FA8C
interval=10
separator=false

[temperature]
label= 
command=for h in /sys/class/hwmon/hwmon*; do [ "$(cat "$h/name")" = k10temp ] && awk '{printf "%.0f°C\n", $1 / 1000}' "$h/temp1_input"; done
color=#F1FA8C
interval=10

[memory]
label= 
command=free -h | awk '/^Mem/ {print $3 "/" $2}'
color=#FFB86C
interval=30
separator=false

[swap]
label= 
command=free -h | awk '/^Swap/ {print $3 "/" $2}'
color=#FFB86C
interval=30

[disk]
label= 
command=df -h / | awk 'NR == 2 {print $4}'
color=#FF79C6
interval=30

[time]
command=date '+%D %T'
color=#BD93F9
interval=5
separator=false

[weather]
label=☀️ 
command=curl -Ss 'https://wttr.in?0&T&Q' | cut -c 16- | head -2 | tail -1 | xargs echo
color=#BD93F9
interval=3600

[restart]
full_text=⏻ 
command=i3-msg -q restart
color=#F8F8F2
EOF
```
> **Nota:** el paquete `i3blocks` de Fedora no incluye los *blocklets* de `/usr/share/i3blocks`, así que cada bloque usa un comando propio. Los íconos requieren la Nerd Font de la guía 02. A la izquierda quedan los lanzadores de Ghostty y VS Code Insiders, que se abren con un clic.

## 4. Configuración de terminal (xfce4-terminal)

Aplicar colores Dracula y fuente Nerd Font:

```bash
mkdir -p ~/.config/xfce4/terminal
# Configuración básica, se recomienda usar xfconf-query para aplicar
xfconf-query -c xfce4-terminal -p /font-name -s "AdwaitaMono Nerd Font 10"
xfconf-query -c xfce4-terminal -p /color-background -s "#282a36"
xfconf-query -c xfce4-terminal -p /color-foreground -s "#f8f8f2"
```

## 5. Notificaciones (dunst)

Configurar `dunst` con tema Dracula, sin bordes y títulos con acento green:

```bash
mkdir -p ~/.config/dunst
cat > ~/.config/dunst/dunstrc << 'EOF'
[global]
    # Display
    monitor = 0
    follow = mouse
    
    # Geometry
    width = 350
    height = (0, 100)
    origin = top-right
    offset = (20, 50)
    
    # Progress bar
    progress_bar = true
    progress_bar_height = 10
    progress_bar_frame_width = 0
    progress_bar_min_width = 150
    progress_bar_max_width = 300
    
    # Appearance - Dracula
    transparency = 0
    separator_height = 2
    padding = 12
    horizontal_padding = 12
    frame_width = 0
    separator_color = "#44475a"
    corner_radius = 8
    
    # Font
    font = AdwaitaMono Nerd Font 9
    line_height = 0
    markup = full
    format = "<b><span foreground='#50fa7b'>%s</span></b>\n%b"
    alignment = left
    vertical_alignment = center
    
    # Behavior
    show_age_threshold = 60
    ellipsize = middle
    ignore_newline = no
    stack_duplicates = true
    hide_duplicate_count = false
    show_indicators = yes
    
    # Icons
    icon_position = left
    min_icon_size = 32
    max_icon_size = 64
    
    # History
    sticky_history = yes
    history_length = 20
    
    # Mouse
    mouse_left_click = close_current
    mouse_middle_click = do_action, close_current
    mouse_right_click = close_all

# Dracula Theme
[urgency_low]
    background = "#282a36"
    foreground = "#6272a4"
    timeout = 5

[urgency_normal]
    background = "#282a36"
    foreground = "#f8f8f2"
    timeout = 10

[urgency_critical]
    background = "#282a36"
    foreground = "#ff5555"
    timeout = 0
EOF
```

Recargar: `pkill dunst && dunst &`

## 6. IDE VS Code Insiders

Se instala desde el repositorio oficial de Microsoft, con verificación de firmas GPG (igual que `config/system/vscode.repo`):

```bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

sudo tee /etc/yum.repos.d/vscode.repo << 'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
autorefresh=1
type=rpm-md
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

sudo dnf check-update; sudo dnf install -y code-insiders
```

Extensiones (tema Dracula y Claude Code):

```bash
code-insiders --install-extension dracula-theme.theme-dracula
code-insiders --install-extension anthropic.claude-code
```

**Configuración (`~/.config/Code - Insiders/User/settings.json`):**
```json
{
    "workbench.colorTheme": "Dracula Theme Soft",
    "terminal.integrated.fontFamily": "'AdwaitaMono Nerd Font'",
    "terminal.integrated.fontSize": 13
}
```

## 7. Asistente de IA (Claude Code)

Instalador nativo: se actualiza solo y no depende de Node.js.

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

El binario queda en `~/.local/bin/claude`. Zsh no incluye esa ruta por defecto; `~/.zshrc` la agrega con:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Verifica con `claude --version` y autentícate ejecutando `claude` la primera vez. Dentro de este repositorio, los comandos `/opsx:*` de OpenSpec quedan disponibles tanto en la terminal como en la extensión de VS Code Insiders.

## Verificación final

Reinicia la sesión o recarga i3 (`Mod+Shift+R`) para ver todos los cambios aplicados.
