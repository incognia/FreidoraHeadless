# Changelog

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
