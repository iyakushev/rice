# !Yuck! QTile needs a PR
# VVVVVVVVVVVV
# type: ignore
import os
import socket
import subprocess
from libqtile import qtile
from libqtile.config import Click, Drag, Group, KeyChord, Key, Screen
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
from libqtile.lazy import lazy
from typing import List


# NOTE: This configuration is mostly taken from the DT (distro tube)
# [https://gitlab.com/dwt1]


def get_wisdom() -> str:
    command = (
        r"fortune | cowsay -f $(ls /usr/share/cowsay/cows | grep .cow | sed s/\\.cow$// | shuf -n 1)",
    )
    return subprocess.run(command, stdout=subprocess.PIPE, shell=True).stdout.decode(
        "utf-8"
    )


MOD_KEY = "mod4"  # Sets mod key to SUPER/WINDOWS
TERMINAL = "alacritty"  # My terminal of choice
WEB_BROWSER = "brave"  # My browser of choice

keys = [
    ### The essentials
    Key([MOD_KEY], "Return", lazy.spawn(f"{TERMINAL}"), desc="Launches My Terminal"),
    Key([MOD_KEY], "d", lazy.spawn("rofi -show drun"), desc="Run Launcher"),
    Key([MOD_KEY], "b", lazy.spawn(WEB_BROWSER), desc="Brave browser, duh"),
    Key(
        ["mod1"],
        "Tab",
        lazy.spawn("rofi -show window"),
        desc="Switch between active windows",
    ),
    Key([MOD_KEY], "Tab", lazy.next_layout(), desc="Toggle through layouts"),
    Key([MOD_KEY], "q", lazy.window.kill(), desc="Kill active window"),
    Key([MOD_KEY, "shift"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([MOD_KEY, "shift"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key(
        ["control", "shift"],
        "e",
        lazy.spawn("emacsclient -c -a emacs"),
        desc="Doom Emacs",
    ),
    Key(
        [MOD_KEY],
        "space",
        lazy.widget["keyboardlayout"].next_keyboard(),
        desc="Keyboard layout change",
    ),
    ### Switch focus to specific monitor (out of three)
    Key([MOD_KEY], "w", lazy.to_screen(0), desc="Keyboard focus to monitor 1"),
    Key([MOD_KEY], "e", lazy.to_screen(1), desc="Keyboard focus to monitor 2"),
    ### Switch focus of monitors
    Key([MOD_KEY], "period", lazy.next_screen(), desc="Move focus to next monitor"),
    Key([MOD_KEY], "comma", lazy.prev_screen(), desc="Move focus to prev monitor"),
    ### Window controls
    Key(
        [MOD_KEY], "j", lazy.layout.down(), desc="Move focus down in current stack pane"
    ),
    Key([MOD_KEY], "k", lazy.layout.up(), desc="Move focus up in current stack pane"),
    Key(
        [MOD_KEY, "shift"],
        "j",
        lazy.layout.shuffle_down(),
        lazy.layout.section_down(),
        desc="Move windows down in current stack",
    ),
    Key(
        [MOD_KEY, "shift"],
        "k",
        lazy.layout.shuffle_up(),
        lazy.layout.section_up(),
        desc="Move windows up in current stack",
    ),

    Key(
        [MOD_KEY, "shift"],
        "h",
        lazy.layout.shuffle_left(),
        lazy.layout.section_left(),
        desc="Move windows left in current stack",
    ),
    Key(
        [MOD_KEY, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        lazy.layout.section_right(),
        desc="Move windows right in current stack",
    ),
    Key(
        [MOD_KEY],
        "h",
        lazy.layout.left().when(layout="bsp"),
        lazy.layout.shrink(),
        lazy.layout.decrease_nmaster(),
        desc="Shrink window (MonadTall), decrease number in master pane (Tile)",
    ),
    Key(
        [MOD_KEY],
        "l",
        lazy.layout.right().when(layout="bsp"),
        lazy.layout.grow(),
        lazy.layout.increase_nmaster(),
        desc="Expand window (MonadTall), increase number in master pane (Tile)",
    ),
    Key(
        ["mod1", "control"],
        "q",
        lazy.spawn(
            [
                "slock",
                "-m",
                get_wisdom(),
            ]
        ),
        desc="Locks your screen",
    ),
    Key([MOD_KEY], "n", lazy.layout.normalize(), desc="normalize window size ratios"),
    Key(
        [MOD_KEY],
        "m",
        lazy.layout.maximize(),
        desc="toggle window between minimum and maximum sizes",
    ),
    Key([MOD_KEY, "shift"], "f", lazy.window.toggle_floating(), desc="toggle floating"),
    Key([MOD_KEY], "f", lazy.window.toggle_fullscreen(), desc="toggle fullscreen"),
    ### Stack controls
    Key(
        [MOD_KEY, "shift"],
        "space",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    # Emacs programs launched using the key chord CTRL+e followed by 'key'
    KeyChord(
        ["control"],
        "e",
        [
            Key([], "e", lazy.spawn("emacsclient -c -a 'emacs'"), desc="Launch Emacs"),
        ],
    ),
]

groups = [
    Group("WWW", layout="monadtall"),
    Group("DEV", layout="monadtall"),
    Group("DOC", layout="monadtall"),
    Group("MSC", layout="monadtall"),
]

# Allow MODKEY+[0 through 9] to bind to groups, see https://docs.qtile.org/en/stable/manual/config/groups.html
# MOD4 + index Number : Switch to Group[index]
# MOD4 + shift + index Number : Send active window to another Group
from libqtile.dgroups import simple_key_binder

dgroups_key_binder = simple_key_binder("mod4")

layout_theme = {
    "border_width": 1,
    "margin": 8,
    "border_focus": "e1acff",
    "border_normal": "1D2330",
}

layouts = [
    # layout.MonadWide(**layout_theme),
    layout.Bsp(**layout_theme),
    # layout.Stack(stacks=2, **layout_theme),
    # layout.Columns(**layout_theme),
    # layout.RatioTile(**layout_theme),
    # layout.Tile(shift_windows=True, **layout_theme),
    # layout.VerticalTile(**layout_theme),
    # layout.Matrix(**layout_theme),
    # layout.Zoomy(**layout_theme),
    layout.MonadTall(**layout_theme),
    # layout.Max(**layout_theme),
    # layout.Stack(num_stacks=2),
    layout.RatioTile(**layout_theme),
    # layout.TreeTab(
    #      font = "Ubuntu",
    #      fontsize = 10,
    #      sections = ["FIRST", "SECOND", "THIRD"],
    #      section_fontsize = 10,
    #      border_width = 2,
    #      bg_color = "1c1f24",
    #      active_bg = "c678dd",
    #      active_fg = "000000",
    #      inactive_bg = "a9a1e1",
    #      inactive_fg = "1c1f24",
    #      padding_left = 0,
    #      padding_x = 0,
    #      padding_y = 5,
    #      section_top = 10,
    #      section_bottom = 20,
    #      level_shift = 8,
    #      vspace = 3,
    #      panel_width = 200
    #      ),
    layout.Floating(**layout_theme),
]

colors = [
    ["#282c34", "#282c34"],
    ["#1c1f24", "#1c1f24"],
    ["#dfdfdf", "#dfdfdf"],
    ["#ff6c6b", "#ff6c6b"],
    ["#98be65", "#98be65"],
    ["#da8548", "#da8548"],
    ["#51afef", "#51afef"],
    ["#c678dd", "#c678dd"],
    ["#46d9ff", "#46d9ff"],
    ["#a9a1e1", "#a9a1e1"],
]

prompt = f"{os.environ['USER']}@{socket.gethostname()}: "

##### DEFAULT WIDGET SETTINGS #####
widget_defaults = {
    "font": "Ubuntu",
    "fontsize": 12,
    "padding": 2,
    "background": colors[0],
}

# extension_defaults = widget_defaults.copy()


def init_widgets_list():
    widgets_list: List[widget] = [
        widget.Sep(linewidth=0, padding=6, foreground=colors[2], background=colors[0]),
        widget.Image(
            filename="~/.config/qtile/icons/cuddlyferris.png",
            scale="False",
            background=colors[0],
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("rofi -show drun")},
        ),
        widget.Sep(linewidth=0, padding=6, foreground=colors[2], background=colors[0]),
        widget.GroupBox(
            font="Ubuntu Bold",
            fontsize=9,
            margin_y=3,
            margin_x=0,
            padding_y=5,
            padding_x=3,
            borderwidth=3,
            active=colors[2],
            inactive=colors[7],
            rounded=False,
            highlight_color=colors[1],
            highlight_method="line",
            this_current_screen_border=colors[6],
            this_screen_border=colors[4],
            other_current_screen_border=colors[6],
            other_screen_border=colors[4],
            foreground=colors[2],
            background=colors[0],
        ),
        widget.TextBox(
            text="|",
            font="Ubuntu Mono",
            background=colors[0],
            foreground="474747",
            padding=2,
            fontsize=14,
        ),
        widget.CurrentLayoutIcon(
            custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
            foreground=colors[2],
            background=colors[0],
            padding=0,
            scale=0.7,
        ),
        widget.CurrentLayout(foreground=colors[2], background=colors[0], padding=5),
        widget.TextBox(
            text="|",
            font="Ubuntu Mono",
            background=colors[0],
            foreground="474747",
            padding=2,
            fontsize=14,
        ),
        widget.WindowName(foreground=colors[6], background=colors[0], padding=0),
        widget.Systray(background=colors[0], padding=5),
        widget.Sep(linewidth=0, padding=6, foreground=colors[0], background=colors[0]),
        widget.Net(
            interface="wlp29s0",
            format="Net: {down} ↓↑ {up}",
            foreground=colors[5],
            background=colors[0],
            padding=5,
        ),
        widget.ThermalSensor(
            foreground=colors[2],
            background=colors[0],
            threshold=90,
            fmt="Temp: {}",
            padding=5,
        ),
        widget.Memory(
            foreground=colors[3],
            background=colors[0],
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(f"{TERMINAL} -e htop")},
            fmt="Mem: {}",
            padding=5,
        ),
        widget.KeyboardLayout(
            foreground=colors[4],
            background=colors[0],
            configured_keyboards=["us", "ru"],
            fmt="Kb: {}",
            padding=5,
        ),
        widget.TextBox(
            text="",
            font="Ubuntu Mono",
            background=colors[0],
            foreground=colors[9],
            padding=0,
            fontsize=37,
        ),
        widget.Clock(
            foreground=colors[1],
            background=colors[9],
            format="%A, %B %d - %H:%M:%S ",
        ),
    ]
    return widgets_list


def init_widgets_screen1():
    widgets_screen1 = init_widgets_list()
    del widgets_screen1[9]
    return widgets_screen1


def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    return widgets_screen2  # Monitor 2 will display all widgets in widgets_list


def init_screens():
    return [
        Screen(top=bar.Bar(widgets=init_widgets_screen1(), opacity=1.0, size=20)),
        Screen(top=bar.Bar(widgets=init_widgets_screen2(), opacity=1.0, size=20)),
    ]


if __name__ in ["config", "__main__"]:
    screens = init_screens()
    widgets_list = init_widgets_list()
    widgets_screen1 = init_widgets_screen1()
    widgets_screen2 = init_widgets_screen2()


def window_to_prev_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i - 1].name)


def window_to_next_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)


def window_to_previous_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i != 0:
        group = qtile.screens[i - 1].group.name
        qtile.current_window.togroup(group)


def window_to_next_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i + 1 != len(qtile.screens):
        group = qtile.screens[i + 1].group.name
        qtile.current_window.togroup(group)


def switch_screens(qtile):
    i = qtile.screens.index(qtile.current_screen)
    group = qtile.screens[i - 1].group
    qtile.current_screen.set_group(group)


mouse = [
    Drag(
        [MOD_KEY],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [MOD_KEY],
        "Button3",
        lazy.window.set_size_floating(),
        start=lazy.window.get_size(),
    ),
    Click([MOD_KEY], "Button2", lazy.window.bring_to_front()),
]

dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False

# floating_layout = layout.Floating(
#     float_rules=[
#         # Run the utility of `xprop` to see the wm class and name of an X client.
#         # default_float_rules include: utility, notification, toolbar, splash, dialog,
#         # file_progress, confirm, download and error.
#         *layout.Floating.default_float_rules,
#         Match(title="Confirmation"),  # tastyworks exit box
#         Match(title="Qalculate!"),  # qalculate-gtk
#         Match(wm_class="kdenlive"),  # kdenlive
#         Match(wm_class="pinentry-gtk-2"),  # GPG key password entry
#     ]
# )
auto_fullscreen = True
focus_on_window_activation = "never"
reconfigure_screens = False

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = False


@hook.subscribe.startup_once
def start_once():
    """Sets background image"""
    home = os.path.expanduser("~")
    subprocess.call([home + "/.config/qtile/autostart.sh"])


# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
