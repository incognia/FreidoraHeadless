# 02 - Instalación del entorno gráfico

Una vez preparado el sistema, instalamos el entorno i3 y las herramientas necesarias. Este paso es prerrequisito para configurar RDP.

## 1. Instalar i3 Window Manager

Instalamos `i3` junto con sus componentes esenciales:

```bash
sudo dnf install -y i3 i3blocks feh
```

- **i3**: el gestor de ventanas.
- **i3blocks**: barra de estado.
- **feh**: gestor de fondo de pantalla.

## 2. Instalar terminal y utilidades XFCE

Instalamos algunas utilidades ligeras de XFCE que se integran bien con i3. `xfce4-terminal` queda como terminal de respaldo; la principal es Ghostty (sección 6).

```bash
sudo dnf install -y xfce4-terminal thunar thunar-archive-plugin mousepad ristretto xfce4-taskmanager xfce4-screenshooter xfce4-settings
```

- **xfce4-terminal**: terminal de respaldo
- **thunar**: gestor de archivos
- **thunar-archive-plugin**: soporte para archivos comprimidos
- **mousepad**: editor de texto simple
- **ristretto**: visor de imágenes
- **xfce4-taskmanager**: monitor de procesos
- **xfce4-screenshooter**: captura de pantalla
- **xfce4-settings**: panel de configuración (apariencia, teclado, ratón, etc.)

## 3. Instalar fuentes (Nerd Fonts)

La configuración de `i3blocks` y la terminal requieren una fuente con íconos parcheados.

```bash
# Crear directorio de fuentes local
mkdir -p ~/.local/share/fonts
cd /tmp

# Descargar e instalar AdwaitaMono Nerd Font
curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/AdwaitaMono.zip
unzip -o AdwaitaMono.zip -d ~/.local/share/fonts/AdwaitaMono
rm AdwaitaMono.zip

# Actualizar caché de fuentes
fc-cache -fv ~/.local/share/fonts
```

## 4. Instalar tema de íconos

Instalamos `Papirus-Dark` para usar en GTK y *apps*.

```bash
sudo dnf install -y papirus-icon-theme
```

## 5. Configurar tema GTK

Configuramos el tema oscuro para aplicaciones GTK 3 y 4.

```bash
mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0

cat > ~/.config/gtk-3.0/settings.ini << 'EOF'
[Settings]
gtk-application-prefer-dark-theme=1
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Papirus-Dark
gtk-cursor-theme-name=Adwaita
gtk-font-name=Sans 9
EOF

cp ~/.config/gtk-3.0/settings.ini ~/.config/gtk-4.0/settings.ini
```

Para GTK 2 (*apps* antiguas):

```bash
cat > ~/.gtkrc-2.0 << 'EOF'
gtk-theme-name="Adwaita-dark"
gtk-icon-theme-name="Papirus-Dark"
gtk-cursor-theme-name="Adwaita"
gtk-font-name="Sans 9"
EOF
```

## 6. Instalar terminal Ghostty

Ghostty es la terminal principal. Fedora no la empaqueta en sus repositorios oficiales; se instala desde el COPR que recomienda el proyecto.

```bash
sudo dnf copr enable -y scottames/ghostty
sudo dnf install -y ghostty
```

Configuración con tema Dracula y la Nerd Font del entorno (igual que `config/dotfiles/.config/ghostty/config`):

```bash
mkdir -p ~/.config/ghostty
cat > ~/.config/ghostty/config << 'EOF'
theme = Dracula
font-family = AdwaitaMono Nerd Font
font-size = 10
window-padding-x = 8
window-padding-y = 8
confirm-close-surface = false
EOF
```

> **Nota sobre RDP:** Ghostty requiere OpenGL 3.3. En la sesión Xvnc no hay GPU y el renderizado es por *software* (Mesa llvmpipe), que es suficiente pero consume más CPU. Si Ghostty no inicia, verifica con `glxinfo -B` (paquete `mesa-demos`) y usa `xfce4-terminal` mientras tanto.

## Siguiente paso

Con el entorno gráfico instalado, ahora podemos configurar el acceso remoto en `03-RDP.md`.
