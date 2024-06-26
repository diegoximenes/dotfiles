[colors]
background = #222
background-alt = #444
foreground = #dfdfdf
foreground-alt = #555
primary = #ffb52a
secondary = #e60053
alert = #bd2c40

[bar/bottom]
monitor = ${env:SCREEN:}
tray-position = ${env:TRAY_POSITION:}
bottom = true
width = 100%
height = ${POLYBAR_BAR_HEIGHT}
offset-x = 0%
offset-y = 0%
radius = 0.0
fixed-center = false
background = ${colors.background}
foreground = ${colors.foreground}
separator = |
line-size = 3
line-color = #f00
border-size = 4
border-color = #00000000
padding = 1
module-margin = 1
tray-maxsize = ${POLYBAR_BAR_TRAY_MAXSIZE}
cursor-click = pointer
cursor-scroll = ns-resize

font-0 = "monospace:size=${POLYBAR_FONT_0_SIZE}:antialias=true"
font-1 = "Noto Color Emoji:scale=${POLYBAR_FONT_1_SCALE}"
font-2 = "Noto Sans Symbols 2:size=${POLYBAR_FONT_2_SIZE}:antialias=true"
font-3 = "Symbols Nerd Font:size=${POLYBAR_FONT_3_SIZE}:antialias=true"

modules-left = i3 i3_split_mode i3_focused_window
modules-right = removable_devices bluetooth light audio_sink audio_source openvpn network cpu_temperature battery date

[settings]
screenchange-reload = true

[global/wm]
margin-top = 0
margin-bottom = 0

[module/i3]
type = internal/i3
index-sort = true
pin-workspaces = true
format = <label-state> <label-mode>
label-mode-foreground = #000
label-mode-background = ${colors.primary}
label-focused = %index%
label-focused-background = ${colors.background-alt}
label-focused-underline = ${colors.primary}
label-focused-padding = 1
label-unfocused = %index%
label-unfocused-padding = 1
label-visible = %index%
label-visible-underline = ${colors.primary}
label-visible-padding = 1
label-urgent = %index%
label-urgent-background = ${colors.alert}
label-urgent-padding = 1

[module/removable_devices]
type = custom/script
exec = ~/.config/polybar/scripts/removable_devices.sh
interval = 2

[module/light]
type = custom/script
exec = ~/.config/polybar/scripts/light.sh --info
tail = true
scroll-up =  ~/.config/polybar/scripts/light.sh --inc
scroll-down = ~/.config/polybar/scripts/light.sh --dec

[module/date]
type = internal/date
interval = 5
date = %a %d-%b-%Y %H:%M

[module/battery]
type = internal/battery
battery = BAT0
adapter = AC
time-format = %H:%M
label-charging = ⚡ %percentage%% %time%
label-discharging = 🌗 %percentage%% %time%
label-full= 🔋 %percentage%%

[module/openvpn]
type = custom/script
exec = ~/.config/polybar/scripts/openvpn.sh
interval = 5

[module/bluetooth]
type = custom/script
exec = ~/.config/polybar/scripts/bluetooth.sh --print_info
tail = true
click-left = ~/.config/polybar/scripts/bluetooth.sh --power_toggle
click-right = rofi-bluetooth

[module/audio_sink]
type = custom/script
exec = ~/.config/polybar/scripts/audio.sh --sink_volume_listener
tail = true
click-right = pavucontrol -t 3
click-left = ~/.config/polybar/scripts/audio.sh --mute_sink
scroll-up =  ~/.config/polybar/scripts/audio.sh --volume_sink_up
scroll-down = ~/.config/polybar/scripts/audio.sh --volume_sink_down

[module/audio_source]
type = custom/script
exec = ~/.config/polybar/scripts/audio.sh --source_volume_listener
tail = true
click-right = pavucontrol -t 4
click-left = ~/.config/polybar/scripts/audio.sh --mute_source
scroll-up = ~/.config/polybar/scripts/audio.sh --volume_source_up
scroll-down = ~/.config/polybar/scripts/audio.sh --volume_source_down

[module/network]
type = custom/script
exec = ~/.config/polybar/scripts/network.sh
interval = 5

[module/cpu_temperature]
type = custom/script
exec = python3 -u ~/.config/polybar/scripts/cpu_temperature.py
tail = true
interval = 20

[module/i3_split_mode]
type = custom/script
exec = python3 -u ~/.config/polybar/scripts/i3_split_mode.py
tail = true

[module/i3_focused_window]
type = custom/script
exec = python3 -u ~/.config/polybar/scripts/i3_focused_window.py
tail = true
