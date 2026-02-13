# Guía de instalación completa del tema Dracula

Esta guía documenta cómo instalar el tema Dracula completo (GTK + iconos + Qt) en Fedora 43.

## 1. Instalación del tema GTK Dracula

### Descargar e instalar tema GTK

```bash
# Crear directorio temporal
cd /tmp

# Descargar tema GTK oficial
wget https://github.com/dracula/gtk/archive/master.zip

# Descomprimir
unzip master.zip

# Renombrar directorio
mv gtk-master Dracula

# Mover a directorio de temas del sistema
sudo mv Dracula /usr/share/themes/

# Limpiar
rm master.zip
```

## 2. Instalación de iconos Dracula

```bash
# Descargar iconos Dracula
cd /tmp
wget https://github.com/dracula/gtk/files/5214870/Dracula.zip

# Descomprimir
unzip Dracula.zip

# Mover a directorio de iconos del sistema
sudo mv Dracula /usr/share/icons/

# Limpiar
rm Dracula.zip
```

## 3. Configuración de GTK 2/3/4

### GTK 2 (~/.gtkrc-2.0)

```bash
cat > ~/.gtkrc-2.0 << 'GTKRC2'
gtk-theme-name="Dracula"
gtk-icon-theme-name="Dracula"
gtk-font-name="Sans 10"
gtk-cursor-theme-name="Adwaita"
gtk-cursor-theme-size=0
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle="hintfull"
GTKRC2
```

### GTK 3 (~/.config/gtk-3.0/settings.ini)

```bash
mkdir -p ~/.config/gtk-3.0

cat > ~/.config/gtk-3.0/settings.ini << 'GTK3'
[Settings]
gtk-application-prefer-dark-theme=1
gtk-theme-name=Dracula
gtk-icon-theme-name=Dracula
gtk-font-name=Sans 10
gtk-cursor-theme-name=Adwaita
gtk-cursor-theme-size=0
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
GTK3
```

### GTK 4 (~/.config/gtk-4.0/settings.ini)

```bash
mkdir -p ~/.config/gtk-4.0

cat > ~/.config/gtk-4.0/settings.ini << 'GTK4'
[Settings]
gtk-application-prefer-dark-theme=1
gtk-theme-name=Dracula
gtk-icon-theme-name=Dracula
GTK4
```

## 4. Instalación y configuración de Qt (qt5ct/qt6ct)

### Instalar paquetes Qt

```bash
sudo dnf install -y qt5ct qt6ct adwaita-qt5 adwaita-qt6
```

### Configurar Qt5ct

```bash
mkdir -p ~/.config/qt5ct/colors

# Crear configuración principal
cat > ~/.config/qt5ct/qt5ct.conf << 'QT5CT'
[Appearance]
color_scheme_path=/home/incognia/.config/qt5ct/colors/Dracula.conf
custom_palette=true
icon_theme=Dracula
standard_dialogs=default
style=Adwaita-Dark

[Fonts]
fixed="Sans Serif,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
general="Sans Serif,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"

[Interface]
activate_item_on_single_click=1
buttonbox_layout=0
cursor_flash_time=1000
dialog_buttons_have_icons=1
double_click_interval=400
keyboard_scheme=2
menus_have_icons=true
show_shortcuts_in_context_menus=true
stylesheets=/usr/share/qt5ct/qss/fusion-fixes.qss, /usr/share/qt5ct/qss/scrollbar-simple.qss, /usr/share/qt5ct/qss/sliders-simple.qss, /usr/share/qt5ct/qss/tooltip-simple.qss, /usr/share/qt5ct/qss/traynotification-simple.qss
toolbutton_style=4
underline_shortcut=1
wheel_scroll_lines=3

[Troubleshooting]
force_raster_widgets=1
ignored_applications=@Invalid()
QT5CT

# Crear esquema de colores Dracula
cat > ~/.config/qt5ct/colors/Dracula.conf << 'DRACULAQT5'
[ColorScheme]
active_colors=#ffbd93f9, #ff424559, #ff484d6b, #ff6272a4, #ff44475a, #ff44475a, #ff6272a4, #ff44475a, #ffbd93f9, #ff282a36, #ff282a36, #ff44475a, #ff6272a4, #ffbd93f9, #ff8be9fd, #ff8be9fd, #ff44475a, #ff6272a4, #ff44475a, #fff8f8f2, #ff44475a
disabled_colors=#ffbd93f9, #ff424559, #ff484d6b, #ff6272a4, #ff44475a, #ff44475a, #ff6272a4, #ff44475a, #ffbd93f9, #ff282a36, #ff282a36, #ff44475a, #ff6272a4, #ffbd93f9, #ff8be9fd, #ff8be9fd, #ff44475a, #ff6272a4, #ff44475a, #fff8f8f2, #ff44475a
inactive_colors=#ffbd93f9, #ff424559, #ff484d6b, #ff6272a4, #ff44475a, #ff44475a, #ff6272a4, #ff44475a, #ffbd93f9, #ff282a36, #ff282a36, #ff44475a, #ff6272a4, #ffbd93f9, #ff8be9fd, #ff8be9fd, #ff44475a, #ff6272a4, #ff44475a, #fff8f8f2, #ff44475a
DRACULAQT5
```

### Configurar Qt6ct

```bash
mkdir -p ~/.config/qt6ct/colors

# Crear configuración principal (igual que Qt5)
cat > ~/.config/qt6ct/qt6ct.conf << 'QT6CT'
[Appearance]
color_scheme_path=/home/incognia/.config/qt6ct/colors/Dracula.conf
custom_palette=true
icon_theme=Dracula
standard_dialogs=default
style=Adwaita-Dark

[Fonts]
fixed="Sans Serif,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
general="Sans Serif,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"

[Interface]
activate_item_on_single_click=1
buttonbox_layout=0
cursor_flash_time=1000
dialog_buttons_have_icons=1
double_click_interval=400
keyboard_scheme=2
menus_have_icons=true
show_shortcuts_in_context_menus=true
stylesheets=/usr/share/qt6ct/qss/fusion-fixes.qss, /usr/share/qt6ct/qss/scrollbar-simple.qss, /usr/share/qt6ct/qss/sliders-simple.qss, /usr/share/qt6ct/qss/tooltip-simple.qss, /usr/share/qt6ct/qss/traynotification-simple.qss
toolbutton_style=4
underline_shortcut=1
wheel_scroll_lines=3

[Troubleshooting]
force_raster_widgets=1
ignored_applications=@Invalid()
QT6CT

# Crear esquema de colores Dracula (igual que Qt5)
cat > ~/.config/qt6ct/colors/Dracula.conf << 'DRACULAQT6'
[ColorScheme]
active_colors=#ffbd93f9, #ff424559, #ff484d6b, #ff6272a4, #ff44475a, #ff44475a, #ff6272a4, #ff44475a, #ffbd93f9, #ff282a36, #ff282a36, #ff44475a, #ff6272a4, #ffbd93f9, #ff8be9fd, #ff8be9fd, #ff44475a, #ff6272a4, #ff44475a, #fff8f8f2, #ff44475a
disabled_colors=#ffbd93f9, #ff424559, #ff484d6b, #ff6272a4, #ff44475a, #ff44475a, #ff6272a4, #ff44475a, #ffbd93f9, #ff282a36, #ff282a36, #ff44475a, #ff6272a4, #ffbd93f9, #ff8be9fd, #ff8be9fd, #ff44475a, #ff6272a4, #ff44475a, #fff8f8f2, #ff44475a
inactive_colors=#ffbd93f9, #ff424559, #ff484d6b, #ff6272a4, #ff44475a, #ff44475a, #ff6272a4, #ff44475a, #ffbd93f9, #ff282a36, #ff282a36, #ff44475a, #ff6272a4, #ffbd93f9, #ff8be9fd, #ff8be9fd, #ff44475a, #ff6272a4, #ff44475a, #fff8f8f2, #ff44475a
DRACULAQT6
```

### Configurar variables de entorno para Qt

Actualizar `~/.xsession` para usar qt5ct:

```bash
# En ~/.xsession, cambiar o agregar:
export QT_QPA_PLATFORMTHEME=qt5ct
export GTK_THEME=Dracula
```

## 5. Instalar LXAppearance (opcional)

Para gestionar temas con GUI:

```bash
sudo dnf install -y lxappearance
```

## 6. Verificación

```bash
# Verificar instalación de temas
ls /usr/share/themes/Dracula
ls /usr/share/icons/Dracula

# Verificar configuraciones
cat ~/.gtkrc-2.0 | grep Dracula
cat ~/.config/gtk-3.0/settings.ini | grep Dracula
cat ~/.config/qt5ct/qt5ct.conf | grep Dracula

# Reiniciar sesión o recargar i3
i3-msg restart
```

## Paleta de colores Dracula

| Color | Hex | Uso |
|-------|-----|-----|
| Background | #282a36 | Fondo principal |
| Current Line | #44475a | Línea actual |
| Selection | #44475a | Selección |
| Foreground | #f8f8f2 | Texto principal |
| Comment | #6272a4 | Comentarios |
| Cyan | #8be9fd | Resaltado |
| Green | #50fa7b | Strings |
| Orange | #ffb86c | Constantes |
| Pink | #ff79c6 | Keywords |
| Purple | #bd93f9 | Functions |
| Red | #ff5555 | Errores |
| Yellow | #f1fa8c | Classes |

## Repositorios oficiales

- Tema GTK: https://github.com/dracula/gtk
- Iconos: Incluidos en el repositorio GTK
- Documentación oficial: https://draculatheme.com/

---

**Nota:** Esta guía fue generada analizando la instalación en un sistema Debian con tema Dracula completamente configurado.
