#!/bin/bash
# Requisitos: ejecutar en la raíz del repo FreidoraHeadless

REPO_ROOT=$(pwd)
CONF_DIR="$REPO_ROOT/conf"

echo "🚀 Iniciando respaldo de configuración de Freidora..."

# 1. Dotfiles (Home)
echo "📦 Respaldando dotfiles..."
cp ~/.zshrc "$CONF_DIR/dotfiles/"
cp ~/.p10k.zsh "$CONF_DIR/dotfiles/"
cp ~/.xsession "$CONF_DIR/dotfiles/"
cp ~/.gtkrc-2.0 "$CONF_DIR/dotfiles/"

# 2. Config folders
mkdir -p "$CONF_DIR/dotfiles/.config"
cp -r ~/.config/i3 "$CONF_DIR/dotfiles/.config/"
cp -r ~/.config/i3blocks "$CONF_DIR/dotfiles/.config/"
cp -r ~/.config/gtk-3.0 "$CONF_DIR/dotfiles/.config/"
cp -r ~/.config/gtk-4.0 "$CONF_DIR/dotfiles/.config/"

# 3. System configs (Etc)
echo "🖥️ Respaldando configuraciones del sistema (requiere sudo para leer algunas)..."
cp /etc/xrdp/km-00000409.ini "$CONF_DIR/system/"
cp /etc/xrdp/sesman.ini "$CONF_DIR/system/"
cp /etc/yum.repos.d/antigravity.repo "$CONF_DIR/system/"

echo "✅ Respaldo completado en $CONF_DIR"
