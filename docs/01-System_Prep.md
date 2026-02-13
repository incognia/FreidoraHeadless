# 01 - Preparación del sistema

Este es el primer paso para preparar un sistema Fedora *headless* (sin monitor) para ser usado como estación de trabajo remota.

## 1. Actualización del sistema

Antes de comenzar, asegúrate de que el sistema esté completamente actualizado.

```bash
sudo dnf update -y
```

Reinicia si hay actualizaciones de *kernel*:

```bash
sudo reboot
```

## 2. Configuración de energía (*headless*)

Para un sistema *headless* al que se accederá remotamente, es crítico deshabilitar la suspensión y la hibernación. Si el sistema se duerme, perderás el acceso remoto.

### Deshabilitar objetivos de suspensión

```bash
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
```

**Verificación:**
Todos deben mostrar `Loaded: masked`.
```bash
systemctl status sleep.target suspend.target hibernate.target hybrid-sleep.target
```

### Configurar sistema en modo multi-usuario (sin interfaz gráfica local)

Para un sistema *headless*, no es necesario que el servidor X local inicie en el arranque. En su lugar, `xrdp` creará sesiones gráficas bajo demanda cuando los usuarios se conecten remotamente.

```bash
# Cambiar el target por defecto a multi-user (sin interfaz gráfica local)
sudo systemctl set-default multi-user.target
```

**Verificación:**
```bash
systemctl get-default
# Debe mostrar: multi-user.target
```

**Nota:** Este cambio se aplica en el siguiente reinicio. El servicio `xrdp` seguirá funcionando normalmente y creará sesiones X cuando los usuarios se conecten vía RDP.

## 3. Configuración de *hostname*

Configura el nombre del equipo para identificarlo correctamente en la red.

```bash
# Ejemplo: tsibi.faraday.org.mx
sudo hostnamectl set-hostname TU_HOSTNAME_AQUI
```

Añade la resolución local en `/etc/hosts`:

```bash
sudo sed -i '3a127.0.0.1   TU_HOSTNAME_AQUI TU_SHORTNAME' /etc/hosts
```

## 3.5. Configuración de red estática

Para entornos sin DHCP, configura una IP estática usando NetworkManager.

### Configuración actual del sistema (tsibi)

**Parámetros de red:**
- **IP:** 10.0.0.79/8
- **Gateway:** 10.0.0.1
- **DNS1:** 8.8.8.8 (Google DNS)
- **DNS2:** 8.8.4.4 (Google DNS)
- **Dominio DNS:** faraday.org.mx
- **Interfaz:** eno1

### Aplicar configuración estática

```bash
# Modificar la conexión existente a IP estática
sudo nmcli connection modify eno1 \
  ipv4.method manual \
  ipv4.addresses 10.0.0.79/8 \
  ipv4.gateway 10.0.0.1 \
  ipv4.dns "8.8.8.8 8.8.4.4" \
  ipv4.dns-search faraday.org.mx

# Desactivar IPv6 (opcional)
sudo nmcli connection modify eno1 ipv6.method disabled

# Aplicar cambios
sudo nmcli connection down eno1 && sudo nmcli connection up eno1
```

### Verificar configuración

```bash
# Ver configuración de la conexión
nmcli connection show eno1 | grep ipv4

# Ver estado de la interfaz
ip addr show eno1
ip route
```

### Revertir a DHCP (si es necesario)

```bash
sudo nmcli connection modify eno1 ipv4.method auto
sudo nmcli connection modify eno1 ipv6.method auto
sudo nmcli connection down eno1 && sudo nmcli connection up eno1
```

**Nota:** Después de aplicar la configuración de red estática, si el equipo se moverá físicamente, apágalo con `sudo poweroff`.

## 4. Autenticación y seguridad (SSH)

Configura el acceso seguro por SSH, preferiblemente usando llaves Ed25519.

### Generar llave SSH (si no tienes una)

```bash
ssh-keygen -t ed25519 -f ~/.ssh/faraday -C "usuario@dominio"
```

### Configuración del agente SSH (`~/.ssh/config`)

Crea o edita `~/.ssh/config` para usar tu llave automáticamente:

```
Host *
    IdentityFile ~/.ssh/faraday
    IdentitiesOnly yes
    AddKeysToAgent yes
```

Establece los permisos correctos:

```bash
chmod 600 ~/.ssh/config
```

### Cargar llave en la sesión actual

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/faraday
```

## Siguiente paso

Una vez preparado el sistema base, procede a instalar el entorno gráfico en `02-Graphical_Env.md`.
