#!/bin/bash
export GTK_THEME=Dracula
export QT_QPA_PLATFORMTHEME=qt5ct
xrandr --output VNC-0 --primary
feh --bg-fill ~/.local/share/backgrounds/default.png &
exec i3
