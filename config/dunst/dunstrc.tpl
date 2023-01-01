[global]
    follow = keyboard
    width = ${DUNST_WIDTH}
    height = ${DUNST_HEIGHT}
    padding = ${DUNST_PADDING}
    horizontal_padding = ${DUNST_HORIZONTAL_PADDING}
    notification_height = 0
    font = Monospace ${DUNST_FONT_SIZE}
    markup = full
    format = "%a:\n%s\n%b"
    word_wrap = true
    icon_position = left

[urgency_low]
    background = "#282828"
    foreground = "#928374"
    timeout = 15

[urgency_normal]
    background = "#458588"
    foreground = "#ebdbb2"
    timeout = 15

[urgency_critical]
    background = "#cc2421"
    foreground = "#ebdbb2"
    frame_color = "#fabd2f"
    timeout = 0
