#!/bin/bash

clip=$(xclip -o -selection clipboard)
[[ "$clip" != "" ]] && notify-send "<b>Clipboard:</b> $clip"
