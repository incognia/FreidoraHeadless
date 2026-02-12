# Entorno de desarrollo *headless* en Fedora 43

![Fedora](https://img.shields.io/badge/Fedora-Server_43-blue?logo=fedora&logoColor=white)
![i3wm](https://img.shields.io/badge/WM-i3-gainsboro?logo=i3&logoColor=black)
![Warp](https://img.shields.io/badge/Terminal-Warp-01B3B3?logo=warp&logoColor=white)
![Antigravity](https://img.shields.io/badge/IDE-Google_Antigravity_Pro-4285F4?logo=google&logoColor=white)
![RDP](https://img.shields.io/badge/Access-RDP_Mac-success)

> ***Vibe coding station*:** configuración minimalista y de alto rendimiento sobre Fedora 43 Server.

Este repositorio documenta la transformación de una instalación limpia de **Fedora 43 Server** en una estación de desarrollo *headless* potente, gestionada remotamente desde macOS vía RDP con soporte para múltiples monitores.

## 🚀 Filosofía

El objetivo es tener un entorno de desarrollo Linux nativo que combine la estabilidad de Fedora con un ritmo de desarrollo rápido (*fast-paced* pero no *bleeding edge* inestable), ideal para *vibe coding*.

- **Base:** Fedora 43 Server (sin *bloatware* gráfico preinstalado).
- **Entorno:** i3 Window Manager (instalación manual).
- **Acceso:** RDP (xrdp) optimizado para clientes Mac y multimonitor.
- **Herramientas:** Warp Terminal + Google Antigravity IDE.

## 🏗 Contexto de *hardware* e instalación

***Hardware:***
- **Cliente personal:** Mac mini M4 (3 monitores).
- **Estación de trabajo:** Dell con Fedora Workstation 43.
- **Servidor *headless*:** HP EliteDesk 705 G4 DM 65W (AMD Ryzen 5 PRO 2400G @ 3.60 GHz, 32GB RAM, AMD Radeon Vega 11).

**Nota sobre la instalación:**
Originalmente se intentó usar la ISO de **Fedora Server DVD** completa, descargada desde la *laptop* Dell del trabajo. Sin embargo, **Fedora Media Writer** falló 3 veces al intentar crear la USB de arranque.

La solución fue descargar la ISO **Fedora Server Net Install**. Con esta imagen, Fedora Media Writer creó el medio de instalación sin problemas, permitiendo el despliegue exitoso del sistema base.

## 🤖 *Workflow* de construcción con IA (*vibe coding*)

Este entorno es producto de un flujo de trabajo asistido por IA:

1.  **Fase de construcción (Warp Terminal):** toda la instalación de paquetes, configuración inicial y borrador de documentación se realizó usando la IA de Warp.
    *   *Inversión:* ~$20 USD (1000 créditos).
2.  **Fase de consolidación (Google Antigravity Pro):** la estructuración, corrección y expansión de esta documentación detallada se realiza utilizando el IDE Antigravity (Plan Pro).

## ❓ ¿Por qué «artesanal»? (frente a Fedora Workstation)

Fedora Workstation incluye soporte RDP sobre Wayland, **pero tiene limitaciones críticas** para este caso de uso:

1.  ***Single monitor*:** la implementación actual de RDP en Gnome/Wayland no admite múltiples monitores virtuales.
2.  **No es realmente *headless*:** requiere un inicio de sesión local físico tras cada reinicio para desbloquear el llavero (*keyring*) y permitir conexiones remotas.

Esta instalación manual sobre **Fedora Server** elimina la dependencia de GDM/Gnome, permitiendo un **inicio de sesión 100 % remoto** y soporte nativo para **3 monitores** desde el cliente RDP de Mac.

## 📚 Guía de instalación

Sigue los documentos en orden para replicar este entorno desde cero:

### 1. [Preparación del sistema](01-System_Prep.md)
Configuración inicial crítica para un sistema *headless*: gestión de energía (evitar suspensión), actualizaciones y seguridad SSH.

### 2. [Entorno gráfico minimalista](02-Graphical_Env.md)
Instalación manual de las «X» y el entorno gráfico.
- `i3` + `i3blocks`
- Fuentes (Nerd Fonts) y temas (Dracula)
- Utilidades base (Thunar, xfce4-terminal)

### 3. [Acceso remoto (RDP)](03-RDP.md)
Configuración de `xrdp` para permitir una experiencia fluida desde macOS.
- *Fixes* para teclado Mac.
- *Workarounds* para *wallpapers*.
- Gestión de sesiones.

### 4. [Configuración y *vibe*](04-Configuration.md)
El «mojo» del sistema. Personalización visual y funcional.
- ***Shell*:** Zsh + Oh My Zsh + Powerlevel10k.
- **IDE:** instalación y configuración de Antigravity.
- **Estética:** tema Dracula global.

### 5. [Mantenimiento](05-Maintenance.md)
*Cheat sheet* de comandos y referencia rápida para el día a día.

## 🛠 *Stack* tecnológico

| Componente | Elección | Razón |
| :--- | :--- | :--- |
| **Distro** | Fedora 43 Server | Base sólida, actualizaciones rápidas de *kernel*/paquetes. |
| **WM** | i3 | Ligero, *tiling* perfecto para *dev*, bajo consumo en RDP. |
| **Terminal** | Warp / xfce4 | IA integrada y *workflows* modernos. |
| **IDE** | Antigravity | La experiencia definitiva de desarrollo asistido. |
| **Remoto** | Microsoft RDP (Mac) | Soporte nativo multimonitor y redirección de dispositivos. |
