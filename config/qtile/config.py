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
from libqtile.config import Key, Screen, Group, Drag
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
from libqtile import extension

# mod4 or mod=super key
mod = "mod4"
mod1 = "alt"
mod2 = "control"
home = os.path.expanduser('~')


@lazy.function
def window_to_prev_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i - 1].name)


@lazy.function
def window_to_next_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)


keys = [
    Key([mod], 'b', lazy.run_extension(extension.WindowList())),
    # FUNCTION KEYS
    Key([], "F12", lazy.spawn('xfce4-terminal --drop-down')),
    # SUPER + FUNCTION KEYS
    Key([mod], "e", lazy.spawn('code')),
    Key([mod], "g", lazy.window.toggle_fullscreen()),
    Key([mod], "m", lazy.spawn('pragha')),
    Key([mod], "q", lazy.window.kill()),
    Key([mod], "r", lazy.spawn('rofi-theme-selector')),
    Key([mod], "w", lazy.spawn('firefox')),
    Key([mod], "t", lazy.spawn('xfce4-terminal')),
    Key([mod], "v", lazy.spawn('xfce4-terminal -e nvim')),
    Key([mod], "Escape", lazy.spawn('xkill')),
    Key([mod], "Return", lazy.spawn('alacritty')),
    Key([mod], "space", lazy.spawn("rofi -modi drun -show drun -show-icons")),
    Key([mod], "c", lazy.spawn('xfce4-terminal  -e cmus')),
    # SUPER + SHIFT KEYS
    Key([mod, "shift"], "Return", lazy.spawn('thunar')),
    Key([mod, "shift"], "r", lazy.restart()),
    Key([mod, "shift"], "l", lazy.shutdown()),
    # CONTROL + ALT KEYS
    Key(["mod1", "control"], "b", lazy.spawn('thunar')),
    Key(["mod1", "control"], "f", lazy.spawn('firefox')),
    Key(["mod1", "control"], "i", lazy.spawn('nitrogen')),
    Key(["mod1", "control"], "o", lazy.spawn(home + '/.config/qtile/scripts/picom-toggle.sh')),
    Key(["mod1", "control"], "r", lazy.spawn('rofi-theme-selector')),
    Key(["mod1", "control"], "s", lazy.spawn('spotify')),
    Key(["mod1", "control"], "t", lazy.spawn('alacritty')),
    Key(["mod1", "control"], "u", lazy.spawn('pavucontrol')),
    Key(["mod1", "control"], "Return", lazy.spawn('alacritty')),
    # MOVE TO SCREEN
    Key(["mod1"], "h", lazy.to_screen(0)),
    Key(["mod1"], "l", lazy.to_screen(1)),
    # VARIETY KEYS WITH PYWAL
    Key(["mod1", "shift"], "f", lazy.spawn(home + '/.config/qtile/scripts/set-pywal.sh -f')),
    Key(["mod1", "shift"], "p", lazy.spawn(home + '/.config/qtile/scripts/set-pywal.sh -p')),
    Key(["mod1", "shift"], "n", lazy.spawn(home + '/.config/qtile/scripts/set-pywal.sh -n')),
    Key(["mod1", "shift"], "u", lazy.spawn(home + '/.config/qtile/scripts/set-pywal.sh -u')),
    # SCREENSHOTS
    Key(["shift"], "Print", lazy.spawn('flameshot gui')),
    Key([], "Print", lazy.spawn('xfce4-screenshooter')),
    # INCREASE/DECREASE BRIGHTNESS
    Key([], "XF86MonBrightnessUp", lazy.spawn("light -A 5")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("light -U 5")),
    Key([mod], "4", lazy.spawn("light -A 5")),
    Key([mod], "3", lazy.spawn("light -U 5")),
    # INCREASE/DECREASE/MUTE VOLUME
    Key([], "XF86AudioMute", lazy.spawn('sh ' + home + '/.config/qtile/scripts/mute-script.sh')),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pamixer -d 5")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pamixer -i 5")),
    Key([mod], "2", lazy.spawn("pamixer -i 5")),
    Key([mod], "1", lazy.spawn("pamixer -d 5")),
    # MUSIC CONTROL
    Key([], "XF86AudioPlay", lazy.spawn("mpc toggle")),
    Key([], "XF86AudioNext", lazy.spawn("mpc next")),
    Key([], "XF86AudioPrev", lazy.spawn("mpc prev")),
    Key([], "XF86AudioStop", lazy.spawn("mpc stop")),
    # QTILE LAYOUT KEYS
    Key([mod], "n", lazy.layout.normalize()),
    Key(["mod1"], "Tab", lazy.next_layout()),
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
    Key([mod, "shift"], "space", lazy.window.toggle_floating()),]


groups = []
# FOR QWERTY KEYBOARDS
group_names = ["a", "s", "d", "f", "u", "i", "o", "p"]
# FOR AZERTY KEYBOARDS
group_labels = ["", "", "", "", "", "", "", ""]
# group_layouts=["monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall",]

for i in range(len(group_names)):
    groups.append(
        Group(
            name=group_names[i],
            # layout=group_layouts[i].lower(),
            label=group_labels[i],
        )
    )

for i in groups:
    keys.extend([
        # CHANGE WORKSPACES
        Key([mod], i.name, lazy.group[i.name].toscreen()),
        Key([mod], "Tab", lazy.screen.next_group()),
        Key([mod, "shift"], "Tab", lazy.screen.prev_group()),

        # MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND STAY ON WORKSPACE
        # Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),
        # MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND FOLLOW MOVED WINDOW TO WORKSPACE
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name), lazy.group[i.name].toscreen()),
    ])


def init_layout_theme():
    return {
        "margin": 2,
        "border_width": 3,
        "border_focus": "#A77AC4",
        "border_normal": "#7197E7"
        }


layout_theme = init_layout_theme()
layouts = [
    layout.MonadTall(**layout_theme),
    # layout.MonadWide(margin=8, border_width=2, border_focus="#5e81ac", border_normal="#4c566a"),
    # layout.Matrix(**layout_theme),
    # layout.Bsp(**layout_theme),
    # layout.Floating(**layout_theme),
    # layout.RatioTile(**layout_theme),
    # layout.Max(**layout_theme)
]

# COLORS FOR THE BAR
colors = {
    "dark":  ["#282a36", "#282a36"],
    "grey":  ["#434758", "#434758"],
    "white": ["#ffffff", "#ffffff"],
    "pink":  ["#A77AC4", "#A77AC4"],
    "blue":  ["#7197E7", "#7197E7"],
    "red":   ["#FF0000", "#FF0000"],
}


# WIDGETS FOR THE BAR
def init_widgets_list():
    # prompt="{0}@{1}: ".format(os.environ["USER"], socket.gethostname())
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
        widget.Image(
            scale=True,
            filename="~/.config/qtile/bluedarkbar.png",
            background=colors["dark"]
        ),
        widget.Battery(
            battery_name="BAT1",
            charge_char='🗲',
            discharge_char='↯',
            foreground=colors["white"],
            background=colors["blue"],
            low_percentage=0.15,
            format='{char} {percent:2.0%}',
            low_foreground=colors["red"],
            update_interval=1,
            fontsize=12
        ),
        widget.Image(
            scale=True,
            filename="~/.config/qtile/pinkbar.png",
            background=colors["pink"]
        ),
        widget.TextBox(
            font="Ubuntu Bold",
            text="",
            foreground=colors["white"],
            background=colors["pink"],
        ),
        widget.CPUGraph(
            foreground=colors["white"],
            background=colors["pink"],
        ),
        widget.TextBox(
            font="Ubuntu Bold",
            text="",
            foreground=colors["white"],
            background=colors["pink"],
        ),
        widget.MemoryGraph(
            foreground=colors["white"],
            background=colors["pink"],
        ),
        widget.Image(
            scale=True,
            filename="~/.config/qtile/bluebar.png",
            background=colors["blue"]
        ),
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
            format="%A, %B %d - %H:%M"
        ),
        widget.Image(
            scale=True,
            filename="~/.config/qtile/pinkbar.png",
            background=colors["pink"]
        ),
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
            background=colors["pink"],
        ),
        widget.Systray(
            background=colors["pink"],
        ),
    ]


screens = [Screen(bottom=bar.Bar(widgets=init_widgets_list(), size=20)),
           Screen(bottom=bar.Bar(widgets=init_widgets_list(), size=20))]

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
# ASSIGN APPLICATIONS TO A SPECIFIC GROUPNAME
# BEGIN
def assign_app_group(client):
    d = {}
    #########################################################
    ################ assgin apps to groups ##################
    #########################################################
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
    ##########################################################
    wm_class = client.window.get_wm_class()[0]

    for i in range(len(d)):
        if wm_class in list(d.values())[i]:
            group = list(d.keys())[i]
            client.togroup(group)
            # I dont like to follow the screen so i commnet this thing
            # client.group.cmd_toscreen()


main = None
follow_mouse_focus = True
bring_front_click = True
cursor_warp = False
floating_types = ["notification", "toolbar", "splash", "dialog"]
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
],  fullscreen_border_width=0, border_width=0)
auto_fullscreen = True
focus_on_window_activation = "smart"  # smart or focus
wmname = "LG3D"


@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/scripts/autostart.sh'])


@hook.subscribe.startup
def start_always():
    # Set the cursor to something sane in X
    subprocess.Popen(['xsetroot', '-cursor_name', 'left_ptr'])


@hook.subscribe.client_new
def set_floating(window):
    if (window.window.get_wm_transient_for()
            or window.window.get_wm_type() in floating_types):
        window.floating = True

