# AGENTS.md

Instrucciones para agentes de IA que trabajan en este repositorio.

## Proyecto

FreidoraHeadless documenta y versiona una estación de desarrollo *headless* sobre **Fedora 44 Server** (host `tsibi`, bare metal x86_64), accesible por RDP (xrdp + Xvnc) desde macOS y Linux, con i3, tema Dracula y Zsh + Powerlevel10k.

El entregable principal es la **documentación**. No hay código de aplicación, compilación ni pruebas automatizadas.

## Estructura

| Ruta | Contenido |
| :--- | :--- |
| `docs/` | Guías numeradas (`01`–`06`) que se siguen en orden. |
| `config/dotfiles/` | Copia de los *dotfiles* reales del host (`~`). |
| `config/system/` | Copia de archivos de `/etc` del host. |
| `scripts/backup.sh` | Copia host → repo. Se ejecuta en `tsibi`, desde la raíz del repo. |
| `scripts/sync.sh` | Copia repo → host. Sobrescribe sin respaldo. |
| `openspec/` | Especificaciones (`specs/`) y cambios (`changes/`) de OpenSpec. |
| `.claude/` | Comandos `/opsx:*` y *skills* de OpenSpec para Claude Code. |

## Flujo de trabajo: SDD con OpenSpec

Todo cambio que afecte al comportamiento del entorno pasa por OpenSpec:

1. **Proponer:** `/opsx:propose` crea `proposal.md`, `specs/`, `design.md` y `tasks.md` en `openspec/changes/<cambio>/`. Solo se planifica; no se implementa en el mismo paso.
2. **Aplicar:** `/opsx:apply` implementa las tareas y marca cada casilla al completarla.
3. **Archivar:** `/opsx:archive` integra los *deltas* en `openspec/specs/`.

Antes de proponer, revisa `openspec list` (cambios en curso) y `openspec list --specs`. Valida con `openspec validate <cambio> --strict`. El contexto del proyecto para OpenSpec está en `openspec/config.yaml`.

Las correcciones menores de documentación (erratas, enlaces, estilo) no necesitan un cambio de OpenSpec.

## Reglas

- **Docs y `config/` van juntos.** Un cambio en el sistema actualiza en el mismo commit la guía de `docs/` y la copia correspondiente en `config/`. Si alguno de los dos se queda atrás, se desfasan.
- **No ejecutes nada contra `tsibi`** ni scripts con `sudo` sin que el usuario lo pida. Las tareas en el host las hace el usuario.
- **Datos sensibles.** No añadas secretos. Trata IPs, dominios, puertos expuestos y nombres de usuario reales como sensibles: usa marcadores en ejemplos nuevos.
- **Seguridad.** No añadas repositorios con `gpgcheck=0` ni servicios expuestos a Internet sin advertirlo explícitamente.

## Convenciones

- **Idioma de la documentación:** español de México. Títulos en tipo oración, comillas angulares («»), cursivas para extranjerismos (*headless*, *dotfiles*, *gaps*).
- **Artefactos de OpenSpec:** en español de México, salvo los encabezados estructurales y las palabras clave `SHALL`/`MUST`, que van en inglés.
- **Commits:** [Conventional Commits](https://www.conventionalcommits.org/) en inglés, atómicos, con ámbito cuando aplique (`docs(rdp): ...`, `feat(i3): ...`).
- **CHANGELOG.md:** en español, orden cronológico inverso, fechas `[AAAA-MM-DD]` en hora del centro de México (CST); una entrada por fecha con viñetas `tipo: descripción`.
- **Licencia:** GPLv3.
