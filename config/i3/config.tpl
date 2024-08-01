# env varibles
set_from_resource $DISPLAY echo "$DISPLAY"

# set modifier: Alt
set $mod Mod1

# font for window titles
font pango:monospace ${I3_FONT_SIZE}

# Use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod

# disable focus cycle
focus_wrapping no

focus_follows_mouse no

# new containers on workspace level default layout
workspace_layout tabbed

# start a terminal
bindsym $mod+Return exec alacritty -t "alacritty" -e tmux new -A -s general

# kill focused window
bindsym $mod+Shift+q kill

# change focus
bindsym $mod+h focus left
bindsym $mod+j focus down
bindsym $mod+k focus up
bindsym $mod+l focus right

# move focused window
bindsym $mod+Shift+h move left
bindsym $mod+Shift+j move down
bindsym $mod+Shift+k move up
bindsym $mod+Shift+l move right

# split mode
bindsym $mod+Shift+n split h
bindsym $mod+Shift+b split v

# default windows splitter for 3 or 4 windows: move last two windows to the right
bindsym $mod+g layout splitv; focus down; focus down; focus down; move right; layout splitv; focus left; move right; move up
# inverse of default windows splitter for 3 or 4 windows
bindsym $mod+b focus right; focus up; move left; focus right; move left; layout tabbed

# change container layout
bindsym $mod+s layout tabbed
bindsym $mod+e layout toggle split

# toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# focus the parent container
bindsym $mod+q focus parent

# focus the child container
bindsym $mod+a focus child

# switch to workspace
bindsym $mod+o workspace prev
bindsym $mod+p workspace next
bindsym $mod+1 workspace 1
bindsym $mod+2 workspace 2
bindsym $mod+3 workspace 3
bindsym $mod+4 workspace 4
bindsym $mod+5 workspace 5
bindsym $mod+6 workspace 6
bindsym $mod+7 workspace 7
bindsym $mod+8 workspace 8
bindsym $mod+9 workspace 9
bindsym $mod+0 workspace 10

# move focused container to workspace and focus in the destination workspace
bindsym $mod+Shift+1 move container to workspace 1; workspace 1
bindsym $mod+Shift+2 move container to workspace 2; workspace 2
bindsym $mod+Shift+3 move container to workspace 3; workspace 3
bindsym $mod+Shift+4 move container to workspace 4; workspace 4
bindsym $mod+Shift+5 move container to workspace 5; workspace 5
bindsym $mod+Shift+6 move container to workspace 6; workspace 6
bindsym $mod+Shift+7 move container to workspace 7; workspace 7
bindsym $mod+Shift+8 move container to workspace 8; workspace 8
bindsym $mod+Shift+9 move container to workspace 9; workspace 9
bindsym $mod+Shift+0 move container to workspace 10; workspace 10

# workspace screen mapping
set $primary_screen HDMI1
set $secondary_screen eDP1
workspace 1 output $secondary_screen
workspace 2 output $secondary_screen
workspace 3 output $secondary_screen
workspace 4 output $secondary_screen
workspace 5 output $secondary_screen
workspace 6 output $primary_screen
workspace 7 output $primary_screen
workspace 8 output $primary_screen
workspace 9 output $primary_screen
workspace 10 output $primary_screen

# restart i3 inplace
bindsym $mod+Shift+r restart

# power management
bindsym $mod+Shift+u exec i3lock -f
bindsym $mod+Shift+i exec --no-startup-id ~/.scripts/prompt_menu.sh "logout?" "i3-msg exit"
bindsym $mod+Shift+o exec --no-startup-id ~/.scripts/prompt_menu.sh "reboot?" "systemctl reboot"
bindsym $mod+Shift+p exec --no-startup-id ~/.scripts/prompt_menu.sh "poweroff?" "systemctl poweroff"

# resize window
bindsym $mod+r mode "resize"
mode "resize" {
        bindsym Left resize shrink width 10 px or 10 ppt
        bindsym Up resize grow height 10 px or 10 ppt
        bindsym Down resize shrink height 10 px or 10 ppt
        bindsym Right resize grow width 10 px or 10 ppt

        bindsym Return mode "default"
        bindsym Escape mode "default"
}

# mouse movement with keyboard
set $large_mouse_delta 80
set $small_mouse_delta 5
bindsym $mod+Control+k exec xdotool mousemove_relative -- 0 -$large_mouse_delta
bindsym $mod+Control+j exec xdotool mousemove_relative -- 0 +$large_mouse_delta
bindsym $mod+Control+h exec xdotool mousemove_relative -- -$large_mouse_delta 0
bindsym $mod+Control+l exec xdotool mousemove_relative -- +$large_mouse_delta 0
bindsym $mod+Control+Shift+k exec xdotool mousemove_relative -- 0 -$small_mouse_delta
bindsym $mod+Control+Shift+j exec xdotool mousemove_relative -- 0 +$small_mouse_delta
bindsym $mod+Control+Shift+h exec xdotool mousemove_relative -- -$small_mouse_delta 0
bindsym $mod+Control+Shift+l exec xdotool mousemove_relative -- +$small_mouse_delta 0

# mouse click with keyboard
bindsym $mod+Control+space exec xdotool click 1
bindsym $mod+Control+Shift+space exec xdotool click 3

# sreen brightness
bindsym XF86MonBrightnessUp exec brightnessctl set +1%
bindsym XF86MonBrightnessDown exec brightnessctl set 1%-

# print screen
bindsym Print exec deepin-screen-recorder

# rofi
bindsym $mod+comma exec rofi -show combi -combi-modi "window#drun" -modi combi

# softwares
bindsym $mod+z exec zathura
bindsym $mod+x exec alacritty -t htop -e htop
bindsym $mod+c exec google-chrome-stable --high-dpi-support=1 --force-device-scale-factor=${I3_GOOGLE_CHROME_SCALE_FACTOR}
bindsym $mod+f exec firefox
bindsym $mod+v exec vlc
bindsym $mod+y exec rofi-bluetooth

# audio
bindsym $mod+m exec ~/.config/polybar/scripts/audio.sh --volume_sink_down
bindsym $mod+i exec ~/.config/polybar/scripts/audio.sh --volume_sink_up
bindsym $mod+n exec ~/.config/polybar/scripts/audio.sh --mute_sink

# configure screens
bindsym $mod+Shift+d exec ~/.scripts/select_display.sh
bindsym $mod+d exec ~/.scripts/select_display.sh --default_config

# show clipboard
bindsym $mod+semicolon exec rofi -modi "clipboard:greenclip print" -show clipboard -run-command "{cmd}"

# back and forth between workspaces
bindsym $mod+t workspace back_and_forth
bindsym $mod+Shift+t move container to workspace back_and_forth

# dunst
bindsym Control+space exec dunstctl close
bindsym Control+Shift+space exec dunstctl close-all
bindsym Control+period exec dunstctl history-pop

# scratchpad terminal
exec --no-startup-id alacritty --class "scratchpad_terminal"
bindsym $mod+Shift+period exec --no-startup-id alacritty --class "scratchpad_terminal"
for_window [class="scratchpad_terminal"] floating enable
for_window [class="scratchpad_terminal"] sticky enable
for_window [class="scratchpad_terminal"] resize set ${I3_SCRATCHPAD_TERMINAL_SIZE}
for_window [class="scratchpad_terminal"] move scratchpad
for_window [class="scratchpad_terminal"] border pixel 10
bindsym $mod+period [class="scratchpad_terminal"] scratchpad show; [class="scratchpad_terminal"] move position center

# floating size
floating_minimum_size 100 x 100
floating_maximum_size ${I3_SCRATCHPAD_MAXIMUM_FLOATING_SIZE}

# set window title
for_window [class=".*"] title_format "%class: %title"

# polybar
exec_always --no-startup-id $HOME/.config/polybar/launch.sh

# default programs startup
exec google-chrome-stable --high-dpi-support=1 --force-device-scale-factor=${I3_GOOGLE_CHROME_SCALE_FACTOR}
exec nm-applet
exec pasystray
exec dunst

# lock screen by inactivity
# exec_always --no-startup-id xautolock -time 15 -locker "i3lock -f"
