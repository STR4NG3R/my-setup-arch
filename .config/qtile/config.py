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
import re
import socket
import subprocess
from libqtile.config import Key, Screen, Group, Drag, Click
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
from typing import List


mod = "mod4"

keys = [

    Key([], "F12", lazy.spawn('yakuake')),

    #Switch screen 0
    Key([mod], "z",lazy.to_screen(0)),
    #Switch screen 1
    Key([mod], "x",lazy.to_screen(1)),

   ### Switch focus of monitors
    Key([mod], "period",lazy.next_screen()), # Move monitor focus to next screen
    Key([mod], "comma", lazy.prev_screen()), # Move monitor focus to prev screen

    # Switch between windows in current stack pane
    Key([mod], "k", lazy.layout.down()),
    Key([mod], "j", lazy.layout.up()),

    # Move windows up or down in current stack
    Key([mod, "control"], "k", lazy.layout.shuffle_down()),
    Key([mod, "control"], "j", lazy.layout.shuffle_up()),

    # Swap panes of split stack
    Key([mod, "shift"], "space", lazy.layout.rotate()),

    # rofi
    Key([mod], "space", lazy.spawn("rofi -modi drun -show drun")),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes

    Key([mod, "shift"], "Return", lazy.layout.toggle_split()),
    Key([mod], "Return", lazy.spawn("alacritty")),
    Key([mod], "Tab", lazy.next_layout()),
    Key([mod, "control"], "r", lazy.restart()),
    Key([mod], "q", lazy.window.kill()),
    Key([mod], "l", lazy.shutdown()),

    # Toggle between different layouts as defined below
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod, "shift"], "h", lazy.layout.swap_left()),
    Key([mod, "shift"], "l", lazy.layout.swap_right()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod], "u", lazy.layout.grow()),
    Key([mod], "y", lazy.layout.shrink()),
    Key([mod], "n", lazy.layout.normalize()),
    Key([mod], "m", lazy.layout.maximize()),
    Key([mod, "shift"], "space", lazy.layout.flip()),

    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous")),
    Key([], "XF86AudioStop", lazy.spawn("playerctl stop")),

    # Audio
    Key([], "XF86AudioMute", lazy.spawn("amixer -q -D pulse sset Master toggle")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")),

    #Brightness
    Key([], "XF86MonBrightnessUp", lazy.spawn("xbacklight -inc 5")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("xbacklight -dec 5")),
    
    #Key([], "XF86PowerDown", lazy.spawn("oblogout")),
    Key([mod], "x", lazy.spawn("oblogout")),

    #To screens
    Key([mod], "o",      lazy.to_screen(1)),
    Key([mod], "p",      lazy.to_screen(0)),

    #Print
    Key([], 'Print', lazy.spawn('screengrab'))

]

#Colors
colors = {
    "dark":  ["#282a36", "#282a36"],
    "grey":  ["#434758", "#434758"],
    "white": ["#ffffff", "#ffffff"],
    "pink":  ["#A77AC4", "#A77AC4"],
    "blue":  ["#7197E7", "#7197E7"],
    "red":   ["#FF0000", "#FF0000"],
}

#Prompt
prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())
#Widgets
widgets_list = [
    widget.Sep(
        linewidth = 0,
        padding = 6,
        foreground = colors["white"],
        background = colors["dark"]
    ),  
    widget.GroupBox(
        font = "Ubuntu Bold",
        fontsize = 9,
        margin_y = 0,
        margin_x = 0,
        padding_y = 9,
        padding_x = 5,
        borderwidth = 1,
        active = colors["white"],
        inactive = colors["white"],
        rounded = False,
        highlight_method = "block",
        this_current_screen_border = colors["pink"],
        this_screen_border = colors ["grey"],
        other_current_screen_border = colors["dark"],
        other_screen_border = colors["dark"],
        foreground = colors["white"],
        background = colors["dark"]
    ),
    widget.Sep(
        linewidth = 0,
        padding = 10,
        foreground = colors["white"],
        background = colors["dark"]
    ),
    widget.WindowName(
        font="Ubuntu Mono",
        fontsize = 11,
        foreground = colors["pink"],
        background = colors["dark"],
        padding = 5
    ),
    widget.Image(
        scale = True,
        filename = "~/.config/qtile/bluedarkbar.png",
        background = colors["dark"]
    ),
    widget.Battery(
        battery_name = "BAT1",
        charge_char = '🗲',
        discharge_char = "↯",
        foreground=colors["white"],
        background=colors["blue"],
        low_percentage = 0.15,
        format = '{char} {percent:2.0%}',
        low_foreground = colors["red"],
        update_interval = 1,
        fontsize=12
    ),
    widget.Image(
        scale = True,
        filename = "~/.config/qtile/pinkbar.png",
        background = colors["dark"]
    ),
    widget.Net(
        interface = ["wlp2s0", "enp3s0"],
        foreground = colors["white"],
        background = colors["pink"],
    ),
    widget.Image(
        scale = True,
        filename = "~/.config/qtile/bluebar.png",
        background = colors["dark"]
    ),
    widget.TextBox(
        text="🔊",
        foreground=colors["white"],
        background=colors["blue"],
        padding = 0,
        fontsize=12
    ),
    widget.Cmus(
        max_chars = 20,
        update_interval = 0.5,
        background=colors["blue"],
        play_color = colors["white"],
        noplay_color = colors["dark"]
    ),
    widget.Volume(
        foreground = colors["white"],
        background = colors["blue"],
        padding = 5
    ),
    widget.Image(
        scale = True,
        filename = "~/.config/qtile/pinkbar.png",
        background = colors["dark"]
    ),
    widget.TextBox(
        font = "Ubuntu Bold",
        text = " ☵",
        padding = 5,
        foreground = colors["white"],
        background = colors["pink"],
        fontsize = 12
    ),
    widget.CurrentLayout(
        foreground = colors["white"],
        background = colors["pink"],
        padding = 5
    ),
    widget.Image(
        scale = True,
        filename = "~/.config/qtile/bluebar.png",
        background = colors["dark"]
    ),
    widget.TextBox(
        font = "Ubuntu Bold",
        text = "🕒",
        foreground = colors["white"],
        background = colors["blue"],
        padding = 5,
        fontsize = 12
    ),
    widget.Clock(
        foreground = colors["white"],
        background = colors["blue"],
        format = "%A, %B %d - %H:%M"
    ),
    widget.Sep(
        linewidth = 0,
        padding = 5,
        foreground = colors["dark"],
        background = colors["blue"]
    ),
    widget.Systray(
        background = colors["dark"],
        padding = 5
    ),
]

# Workspaces
groups = [Group(i) for i in ["NET", "DEV", "TERM", "MEDIA"]]
for i in range(len(groups)):
    actual_key = i + 1
    keys.extend([
        Key([mod], str(actual_key), lazy.group[groups[i].name].toscreen()),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, "shift"], str(actual_key), lazy.window.togroup(groups[i].name)),
    ])

layouts = [
    layout.Max(),
    layout.MonadTall(border_focus = colors["pink"][0], border_width = 1, margin = 1),
    # Try more layouts by unleashing below layouts.
    # layout.Bsp(),
    # layout.Columns(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font='sans',
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            widgets_list,
            24,
            opacity=0.95
        ),
    ),
    Screen(
        top=bar.Bar(
            widgets_list,
            24,
            opacity=0.95
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
        start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
        start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
    {'wname': 'screengrab'},  # GPG key password entry
    {'wname': "Openbox Logout"}, 
])
auto_fullscreen = True
focus_on_window_activation = "smart"

#STARTUP APPLICATIONS 
@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
