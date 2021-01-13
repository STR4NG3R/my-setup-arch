# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess

from libqtile import bar, extension, hook, layout, widget
from libqtile.command import lazy
from libqtile.config import Drag, Group, Key, Screen

# mod4 or mod=super key
mod = "mod4"
mod1 = "alt"
mod2 = "control"
home = os.path.expanduser('~')

current_screen = 0
max_screens = 0


def switch_screen(index, lazy):
    @lazy.function
    def __inner(qtile):
        global current_screen, max_screens
        current_screen += index
        if current_screen >= 0 and current_screen < max_screens:
            lazy.to_screen(current_screen)
        else:
            current_screen -= index
        lazy.spawn(f'notify-send "Move to Screen {current_screen}"')
    return __inner


keys = [
    Key([mod], 'b', lazy.run_extension(extension.WindowList())),
    # SUPER + FUNCTION KEYS
    Key([mod], "e", lazy.spawn('code')),
    Key([mod], "g", lazy.window.toggle_fullscreen()),
    Key([mod], "m", lazy.spawn('pragha')),
    Key([mod], "q", lazy.window.kill()),
    Key([mod], "r", lazy.spawn('rofi-theme-selector')),
    Key([mod], "w", lazy.spawn('firefox')),
    Key([mod], "v", lazy.spawn('nvim')),
    Key([mod], "Escape", lazy.spawn('xkill')),
    Key(["mod1"], "p", lazy.spawn('xprop')),
    Key([mod], "Return", lazy.spawn('alacritty')),
    Key([mod], "space",
        lazy.spawn(home + '/.config/rofi/launchers/misc/launcher.sh')),
    # Key([mod], "space",lazy.spawn("rofi -modi drun -show drun -show-icons")),
    Key([mod], "c", lazy.spawn('alacritty  -e cmus')),
    # SUPER + SHIFT KEYS
    Key([mod, "shift"], "Return", lazy.spawn('thunar')),
    Key([mod, "shift"], "r", lazy.restart()),
    Key([mod, "shift"], "w", lazy.shutdown()),
    # CONTROL + ALT KEYS
    # Key(["mod1"], "l",
    #    lazy.spawn(home + '/.config/rofi/bin/applet_powermenu')),
    # Key(["mod1"], "l", lazy.spawn('applet_powermenu')),
    Key(["mod1", "control"], "r", lazy.spawn('rofi-theme-selector')),
    Key(["mod1", "control"], "u", lazy.spawn('pavucontrol')),
    Key(["mod1", "control"], "Return", lazy.spawn('alacritty')),
    # MOVE TO SCREEN
    # Key([mod, "mod1"], "h", lazy.to_screen(0)),
    # Key([mod, "mod1"], "l", lazy.to_screen(1)),
    Key([mod, "mod1"], "h", switch_screen(-1, lazy)),
    Key([mod, "mod1"], "l", switch_screen(1, lazy)),
    # SCREENSHOTS
    Key(["shift"], "Print", lazy.spawn('flameshot gui')),
    Key([], "Print", lazy.spawn('xfce4-screenshooter')),
    # INCREASE/DECREASE BRIGHTNESS
    Key([], "XF86MonBrightnessUp", lazy.spawn("light -A 5")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("light -U 5")),
    Key([mod], "4", lazy.spawn("light -A 5")),
    Key([mod], "3", lazy.spawn("light -U 5")),
    # INCREASE/DECREASE/MUTE VOLUME
    Key([], "XF86AudioMute",
        lazy.spawn('sh ' + home + '/.config/scripts/mute-script.sh')
        ),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pamixer -d 5")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pamixer -i 5")),
    Key([mod], "2", lazy.spawn("pamixer -i 5")),
    Key([mod], "1", lazy.spawn("pamixer -d 5")),
    # MUSIC CONTROL
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl prev")),
    Key([], "XF86AudioStop", lazy.spawn("playerctl stop")),
    # QTILE LAYOUT KEYS
    Key([mod], "n", lazy.layout.normalize()),
    Key(["mod1"], "Tab", lazy.next_layout()),
    # NOTIFY KEY LOCK
    Key([], "Caps_Lock",
            lazy.spawn(home + '/.config/scripts/keylock.sh caps')
        ),
    Key([], "Num_Lock",
            lazy.spawn(home + '/.config/scripts/keylock.sh num')
        ),
    # CHANGE FOCUS
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
    # RESIZE UP, DOWN, LEFT, RIGHT
    Key([mod, "control"], "l",
        lazy.layout.grow(),
        lazy.layout.grow_right()
        ),
    Key([mod, "control"], "h",
        lazy.layout.shrink(),
        lazy.layout.grow_left(),
        ),
    Key([mod, "control"], "k",
        lazy.layout.grow(),
        lazy.layout.grow_up(),
        ),
    Key([mod, "control"], "j",
        lazy.layout.shrink(),
        lazy.layout.grow_down(),
        ),
    # FLIP LAYOUT FOR MONADTALL/MONADWIDE
    Key([mod, "shift"], "f", lazy.layout.flip()),
    # MOVE WINDOWS UP OR DOWN MONADTALL/MONADWIDE LAYOUT
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "h", lazy.layout.swap_left()),
    Key([mod, "shift"], "l", lazy.layout.swap_right()),
    # TOGGLE FLOATING LAYOUT
    Key([mod, "shift"], "space", lazy.window.toggle_floating())
    ]


groups = []
# FOR QWERTY KEYBOARDS
group_names = ["a", "s", "d", "f", "u", "i", "o", "p"]
# FOR AZERTY KEYBOARDS
group_labels = ["", "", "", "", "", "", "", ""]

for i in range(len(group_names)):
    groups.append(
        Group(name=group_names[i], label=group_labels[i])
    )

for i in groups:
    keys.extend([
        # CHANGE WORKSPACES
        Key([mod], i.name, lazy.group[i.name].toscreen()),
        Key([mod], "Tab", lazy.screen.next_group()),
        Key([mod, "shift"], "Tab", lazy.screen.prev_group()),
        # MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND STAY ON WORKSPACE
        # Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),
        Key([mod, "shift"],
            i.name,
            lazy.window.togroup(i.name),
            lazy.group[i.name].toscreen()
            )
    ])

# COLORS FOR THE BAR
colors = {
    "dark":  ["#282a36"],
    "grey":  ["#434758"],
    "white": ["#ffffff"],
    "pink":  ["#A77AC4"],
    "blue":  ["#7197E7"],
    "red":   ["#FF0000"]
}


def init_layout_theme():
    return {
        "margin": 3,
        "border_width": 2,
        "border_focus": "#A77AC4",
        "border_normal": "#7197E7"
    }


layout_theme = init_layout_theme()
layouts = [
    layout.MonadTall(**layout_theme),
    # layout.MonadWide(**layout_theme),
    # border_focus="#5e81ac", border_normal="#4c566a"),
    # layout.Matrix(**layout_theme),
    # layout.Bsp(**layout_theme),
    # layout.Floating(**layout_theme),
    # layout.RatioTile(**layout_theme),
    # layout.Max(**layout_theme)
]


def color_separator(background, foreground):
    return widget.TextBox(
        text="",
        padding=-4,
        fontsize=34,
        background=colors[background],
        foreground=colors[foreground]
    )


# WIDGETS FOR THE BAR
def init_widgets_list():
    return [
        widget.GroupBox(
            font="Ubuntu Bold",
            fontsize=11,
            padding_y=9,
            padding_x=5,
            borderwidth=1,
            active=colors["white"],
            inactive=colors["grey"],
            rounded=True,
            highlight_method="block",
            this_current_screen_border=colors["pink"],
            this_screen_border=colors["dark"],
            other_current_screen_border=colors["dark"],
            other_screen_border=colors["dark"],
            foreground=colors["white"],
            background=colors["dark"]
        ),
        widget.Sep(
            linewidth=0,
            foreground=colors["white"],
            background=colors["dark"]
        ),
        widget.WindowName(
            font="Ubuntu Mono",
            fontsize=11,
            foreground=colors["pink"],
            background=colors["dark"],
        ),
        color_separator("dark", "blue"),
        widget.Battery(
            battery_name="BAT1",
            charge_char='',
            discharge_char='',
            foreground=colors["white"],
            background=colors["blue"],
            low_percentage=0.15,
            format='{char} {percent:2.0%}',
            low_foreground=colors["red"],
            update_interval=1,
            fontsize=12
        ),
        color_separator("blue", "pink"),
        widget.TextBox(
            font="Ubuntu Bold",
            text="",
            foreground=colors["white"],
            background=colors["pink"]
        ),
        widget.CPUGraph(
            foreground=colors["white"],
            background=colors["pink"]
        ),
        widget.TextBox(
            font="Ubuntu Bold",
            text="",
            foreground=colors["white"],
            background=colors["pink"]
        ),
        widget.MemoryGraph(
            foreground=colors["white"],
            background=colors["pink"]
        ),
        color_separator("pink", "blue"),
        widget.TextBox(
            font="Ubuntu Bold",
            text="",
            foreground=colors["white"],
            background=colors["blue"],
            fontsize=11
        ),
        widget.Clock(
            foreground=colors["white"],
            background=colors["blue"],
            format="%Y-%m-%d  %H:%M"
        ),
        color_separator("blue", "pink"),
        widget.Cmus(
            max_chars=25,
            update_interval=0.5,
            background=colors["pink"],
            play_color=colors["white"],
            noplay_color=colors["dark"]
        ),
        widget.TextBox(
            text="🔊",
            foreground=colors["white"],
            background=colors["pink"],
            fontsize=12
        ),
        widget.PulseVolume(
            foreground=colors["white"],
            background=colors["pink"]
        ),
        widget.Systray(
            background=colors["pink"]
        ),
    ]


monitors = subprocess.run(
    'xrandr | grep "\*" | cut -d" " -f4',
    shell=True,
    stdout=subprocess.PIPE
).stdout.decode("UTF-8").strip().split('\n')

screens = []

max_screens = len(monitors)
for monitor in monitors:
    res = monitor.split('x')
    screens.append(
        Screen(
            width=res[0],
            height=res[1],
            bottom=bar.Bar(
                opacity=.80,
                widgets=init_widgets_list(),
                size=20
            )
        )
    )

# MOUSE CONFIGURATION
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size())
]

dgroups_key_binder = None
dgroups_app_rules = []


@hook.subscribe.client_new
def assign_app_group(client):
    d = {}
    d["a"] = ["Navigator", "Firefox",
              "navigator", "firefox", ]

    d["s"] = ["QTCreator", "Brackets", "Code-oss", "Code", "Discord",
              "qtcreator", "brackets", "code-oss", "code", "discord"]

    d["d"] = ["PacketTracer7"]

    d["f"] = ["DBeaver", "Postman",
              "dbeaver", "postman"]

    d["u"] = ["Inkscape", "inkscape", "Gimp", "gimp", "kdenlive"]

    d["i"] = ["Zoom",
              "zoom", ]

    d["o"] = ["Thunar",
              "thunar", ]

    d["p"] = ["Evolution", "Geary", "Mail", "Thunderbird", "TelegramDesktop",
              "evolution", "geary", "mail", "thunderbird", "telegramDesktop"]
    wm_class = client.window.get_wm_class()[0]

    for i in range(len(d)):
        if wm_class in list(d.values())[i]:
            group = list(d.keys())[i]
            client.togroup(group)
            # I dont like to follow the window open in screen so i commnet it
            # client.group.cmd_toscreen()


main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_types = ["notification", "toolbar", "splash", "dialog", "utility"]
floating_layout = layout.Floating(float_rules=[
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},
    {'wmclass': 'makebranch'},
    {'wmclass': 'maketag'},
    {'wmclass': 'Arandr'},
    {'wmclass': 'Galculator'},
    {'wname': 'branchdialog'},
    {'wmclass': 'flameshot'},
    {'wmclass': 'pavucontrol'},
    {'wmclass': 'xfce4-terminal'},
    {'wmclass': 'xfce4-screenshooter'},
    {'wname': 'Open File'},
    {'wname': 'pinentry'},
    {'wmclass': 'feh'},
    {'wmclass': 'ssh-askpass'},
    {'wmclass': 'gpick'},
    {'wmclass': 'zoom'},
],  fullscreen_border_width=0, border_width=0)
auto_fullscreen = True
focus_on_window_activation = "focus"  # smart or focus
wmname = "LG3D"


@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/scripts/autostart.sh'])


@hook.subscribe.startup
def start_always():
    # Set the cursor to something sane in X
    subprocess.Popen(['xsetroot', '-cursor_name', 'left_ptr'])


@hook.subscribe.client_new
def set_floating(window):
    if (window.window.get_wm_transient_for()
            or window.window.get_wm_type() in floating_types):
        window.floating = True
