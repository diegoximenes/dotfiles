import i3ipc

i3 = i3ipc.Connection()


def get_split_mode():
    parent = i3.get_tree().find_focused().parent
    if parent.layout == "splitv":
        print("V")
    elif parent.layout == "splith":
        print("H")


def on_event(self, _):
    get_split_mode()


if __name__ == "__main__":
    get_split_mode()

    i3.on("window::focus", on_event)
    i3.on("binding", on_event)

    i3.main()
