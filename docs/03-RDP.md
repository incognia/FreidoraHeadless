# 03 - Configuración de acceso remoto (RDP)

Con el entorno gráfico listo, configuramos el acceso vía `xrdp` para controlar el sistema remotamente.

## 1. Instalación del servidor RDP

Instalamos los paquetes necesarios para el servidor RDP.

```bash
sudo dnf install -y xrdp xrdp-selinux tigervnc-server-minimal
```

## 2. Configuración de sesión (`.xsession`)

`xrdp` necesita saber qué gestor de ventanas iniciar. Creamos el archivo `~/.xsession` que inicia `i3` y establece el fondo de pantalla.

```bash
cat > ~/.xsession << 'XSESSION'
#!/bin/bash
# Cargar variables de entorno para GTK
export GTK_THEME=Adwaita:dark
export QT_QPA_PLATFORMTHEME=gtk2

# Establecer wallpaper (ver sección Siguiente sobre conversión)
feh --bg-fill ~/.local/share/backgrounds/default.png &

# Iniciar i3
exec i3
XSESSION

chmod +x ~/.xsession
```

> **Nota:** sin este archivo, la sesión se cerrará inmediatamente.

## 3. Preparar *wallpaper* (*workaround* JXL)

Fedora incluye *wallpapers* en formato JXL, incompatible con `feh`. Convertimos el predeterminado a PNG.

```bash
sudo dnf install -y libjxl-utils
mkdir -p ~/.local/share/backgrounds

# Convertir wallpaper
djxl /usr/share/backgrounds/default.jxl ~/.local/share/backgrounds/default.png
```

## 4. Habilitar servicio y *firewall*

```bash
# Habilitar servicio xrdp
sudo systemctl enable --now xrdp

# Abrir puerto 3389
sudo firewall-cmd --permanent --add-port=3389/tcp
sudo firewall-cmd --reload
```

## 5. Solución de problemas comunes

### Teclado Mac (*layout* incorrecto)

Si te conectas desde un Mac, el mapeo de teclas puede ser incorrecto.

```bash
# Reemplazar keymap US con el latinoamericano
sudo cp /etc/xrdp/km-0000080a.ini /etc/xrdp/km-00000409.ini
sudo systemctl restart xrdp
```

### Limpieza de sesiones

Para evitar que sesiones desconectadas consuman recursos, configuramos `xrdp` para terminarlas al desconectar.

```bash
sudo sed -i 's/^KillDisconnected=false/KillDisconnected=true/' /etc/xrdp/sesman.ini
sudo systemctl restart xrdp-sesman
```

## 6. Acceso al sistema

El sistema puede accederse de dos formas dependiendo de tu ubicación:

### Desde red local (LAN)

**Parámetros de conexión:**
- **Host:** `10.0.0.79`
- **Puerto:** `3389`
- **Usuario:** `incognia`

**Ejemplo (cliente RDP de macOS):**
```
rdp://10.0.0.79:3389
```

### Desde red externa (Internet)

**Parámetros de conexión:**
- **Host:** `faraday.org.mx`
- **Puerto:** `3390` (mapeado a 3389 interno vía pfSense)
- **Usuario:** `incognia`

**Ejemplo (cliente RDP de macOS):**
```
rdp://faraday.org.mx:3390
```

**Nota sobre seguridad:**
El acceso externo está protegido por:
- Port forwarding en pfSense (3390 → 3389)
- Firewall local (puerto 3389 abierto)
- Autenticación de usuario en xrdp

### Configuración de cliente (macOS)

Para mejor experiencia con 3 monitores:
1. Abrir Microsoft Remote Desktop
2. Agregar PC con los parámetros correspondientes
3. En *Display*: seleccionar "Use all monitors"
4. En *Display*: activar "Start session in full screen"

## Siguiente paso

Ahora puedes conectarte vía RDP. El entorno se verá básico hasta que apliquemos la configuración detallada en `04-Configuration.md`.
