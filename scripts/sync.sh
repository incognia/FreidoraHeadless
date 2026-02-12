#!/bin/bash
# Requisitos: ejecutar en la raíz del repo FreidoraHeadless

REPO_ROOT=$(pwd)
CONF_DIR="$REPO_ROOT/conf"

echo "🔄 Iniciando sincronización de configuración hacia el sistema..."

# 1. Dotfiles (Home)
echo "📦 Restaurando dotfiles..."
cp "$CONF_DIR/dotfiles/.zshrc" ~/
cp "$CONF_DIR/dotfiles/.p10k.zsh" ~/
cp "$CONF_DIR/dotfiles/.xsession" ~/
cp "$CONF_DIR/dotfiles/.gtkrc-2.0" ~/

# 2. Config folders
echo "📦 Restaurando carpetas .config..."
cp -r "$CONF_DIR/dotfiles/.config/"* ~/.config/

# 3. System configs (Etc)
echo "🖥️ Restaurando configuraciones del sistema (requiere sudo)..."
sudo cp "$CONF_DIR/system/km-00000409.ini" /etc/xrdp/
sudo cp "$CONF_DIR/system/sesman.ini" /etc/xrdp/
sudo cp "$CONF_DIR/system/antigravity.repo" /etc/yum.repos.d/

echo "✅ Sincronización completada. Es posible que necesites reiniciar i3 o xrdp."
