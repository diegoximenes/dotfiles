#!/bin/bash

# required by xdg-desktop-portal-gtk
systemctl --user import-environment DISPLAY XAUTHORITY
dbus-update-activation-environment --systemd DISPLAY XAUTHORITY

# needed by keyd
setxkbmap -option compose:menu

source "$HOME/.scripts/select_display.sh" --default_config
source "$HOME/.scripts/generate_configs_dependent_on_screen.sh"

# systemd greeclip.service is not working
if ! pgrep -x greenclip >/dev/null; then
    greenclip daemon &
fi

exec i3
