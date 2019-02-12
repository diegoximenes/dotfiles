import i3ipc

MAX_TITLE_LEN = 20
i3 = i3ipc.Connection()


def get_window_title():
    focused = i3.get_tree().find_focused()
    if focused.window_class is None:
        print("")
    else:
        title = "{}: {}".format(focused.window_class, focused.name)
        if (len(title) > MAX_TITLE_LEN):
            print("{}...".format(title[:MAX_TITLE_LEN]))
        else:
            print(title)


def on_event(self, _):
    get_window_title()


if __name__ == "__main__":
    get_window_title()
    i3.on("window::focus", on_event)
    i3.on("window::title", on_event)
    i3.on("window::close", on_event)
    i3.on("workspace::focus", on_event)
    i3.main()
