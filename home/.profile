#!/bin/bash

# systemd greeclip.service is not working
if ! pgrep -x greenclip >/dev/null; then
    greenclip daemon &
fi

# starts graphical server if i3 is not already running
[[ "$(tty)" == "/dev/tty1" ]] && ! pgrep -x i3 >/dev/null && exec startx
