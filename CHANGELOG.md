# Changelog

## [2026-10-19] - Adopción de desarrollo guiado por especificaciones (SDD)

- docs: registrar en el cambio de OpenSpec add-iac-provisioning los resultados de la prueba técnica (hallazgos de libvirt en macOS, HVF y xrdp), el requisito de contraseña opcional para RDP con Xvnc como única sesión y el avance de tareas (20 de 24)
- docs: agregar la guía 07 de infraestructura como código, enlazar las guías 06 y 07 en el README con Terraform y Ansible en el stack, y documentar «infra/» en AGENTS.md
- feat: agregar *playbook* de Ansible con ocho roles (base, network, ssh, desktop, rdp, theme, shell, devtools) e inventarios de ejemplo para *bare metal* y VM
- feat: versionar en «config/» la configuración de dunst, qt5ct, qt6ct y un «xrdp.ini» con Xvnc como única sesión, incluirlos en «backup.sh» y «sync.sh», y documentarlo en la guía 03
- feat: agregar módulo de Terraform para una VM Fedora 44 aarch64 en macOS con libvirt, HVF, cloud-init y SSH/RDP solo en *localhost*
- feat: agregar LaunchAgent de macOS para un «libvirtd» de sesión persistente
- chore: ignorar el estado de Terraform, «terraform.tfvars» y los inventarios reales de Ansible
- docs: actualizar las tareas de replace-dev-tooling (11 de 15 completadas; la 4.2 aplica a mano en el host solo los cambios de configuración en lugar de «sync.sh», y nueva 4.4 para ejecutar «backup.sh» después)
- docs: retirar Warp y Antigravity del README, de las guías 04 y 05, de i3blocks y de los scripts «backup.sh» y «sync.sh» y eliminar «antigravity.repo», como parte de la aplicación del cambio de OpenSpec replace-dev-tooling
- feat: instalar Claude Code con el instalador nativo y agregar «~/.local/bin» al PATH en «.zshrc» (guía 04)
- feat: instalar VS Code Insiders desde el repositorio de Microsoft con «gpgcheck=1» (guía 04 y «config/system/vscode.repo»)
- feat: adoptar Ghostty como terminal principal (guía 02, configuración en «config/dotfiles/.config/ghostty», atajo Mod+Enter y lanzador en i3blocks)
- chore: eliminar «.agents/» (comandos de OpenSpec para Antigravity), eliminar «config.bak» de i3blocks e ignorar «*.bak» en «.gitignore»
- docs: agregar propuesta de OpenSpec add-iac-provisioning (VM Fedora en macOS con Terraform y libvirt, y configuración con Ansible para *bare metal* y VM)
- docs: agregar propuesta de OpenSpec replace-dev-tooling (Claude Code, VS Code Insiders y Ghostty en lugar de Warp y Antigravity)
- feat: inicializar OpenSpec (esquema spec-driven, artefactos en es-MX)
- feat: agregar comandos y skills de OpenSpec para Claude Code y Antigravity
- docs: reorientar el README de *vibe coding* a SDD y documentar el flujo de OpenSpec
- docs: agregar AGENTS.md con instrucciones para agentes y CLAUDE.md que lo importa

## [2026-06-04] - Colección de wallpapers y ajustes de i3

- feat: configurar dunst con tema Dracula y títulos green
- docs: agregar screenshot del entorno en display ultrawide 32:9
- docs: documentar clientes RDP probados (macOS 3x1080p, Remmina ultrawide 32:9)
- feat: instalar colección completa de wallpapers Fedora (F34-F44)
- feat: crear alias reloadbg para recargar wallpaper
- feat: aumentar gaps de i3 de 8px a 16px
- docs: documentar instalación y uso de wallpapers con conversión JXL a PNG
- docs: documentar alias reloadbg en cheat sheet de mantenimiento

## [2026-06-03] - Sincronización de wallpapers y corrección de iconos

- feat: actualizar sistema de Fedora 43 a Fedora 44
- fix: desactivar xss-lock para evitar bloqueo de pantalla en entorno headless
- docs: actualizar referencias de Fedora 43 a 44 en README y guías
- docs: documentar desactivación de screensaver en configuración de i3
- feat: copiar wallpaper Dracula de Fedora desde servidor Debian (10.0.0.199)
- fix: corregir tema de iconos GTK3/GTK4 de breeze-dark a Dracula

## [2026-02-13] - Configuración headless completa

- feat: configurar sistema en modo multi-user (sin interfaz gráfica local)
- docs: documentar configuración de target del sistema en 01-System_Prep.md
- docs: agregar comandos de gestión de target en 05-Maintenance.md
- docs: documentar configuración de red estática (10.0.0.79/8)
- docs: agregar información de acceso RDP desde red local y externa
- docs: agregar guía completa de instalación del tema Dracula (GTK + iconos + Qt)
- feat: ajustar gaps de i3 a 8px con smart_gaps off
- feat: instalar xfce4-settings para panel de configuración
- feat: aplicar tema Dracula completo (GTK2/3/4 + iconos + Qt5ct/Qt6ct)
- docs: actualizar guía Dracula con configuración probada en Fedora 43

## [2026-02-11] - Reorganización y configuración de backups

- refactor: rename conf directory to config and update scripts
- refactor: reorganize project structure and setup backup scripts

## [2026-02-11] - Licenciamiento y Documentación de Hardware

- feat: add GPLv3 license
- docs: update hardware specs in README

## [2026-02-11] - Inicialización del Proyecto

- feat: initial project setup
