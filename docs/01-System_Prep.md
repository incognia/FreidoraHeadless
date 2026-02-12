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
