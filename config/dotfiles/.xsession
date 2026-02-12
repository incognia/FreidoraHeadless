#!/bin/bash
export GTK_THEME=Adwaita:dark
export QT_QPA_PLATFORMTHEME=gtk2
xrandr --output VNC-0 --primary
feh --bg-fill ~/.local/share/backgrounds/default.png &
exec i3
