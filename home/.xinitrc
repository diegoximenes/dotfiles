#!/bin/bash

# systemd greeclip.service is not working
if ! pgrep -x greenclip >/dev/null; then
    greenclip daemon &
fi

exec i3
