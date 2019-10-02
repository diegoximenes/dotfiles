#!/bin/bash

# starts graphical server if i3 is not already running
[[ "$(tty)" == "/dev/tty1" ]] && ! pgrep -x i3 >/dev/null && exec startx
