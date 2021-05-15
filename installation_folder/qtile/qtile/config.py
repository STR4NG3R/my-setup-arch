import os
import subprocess

from libqtile import bar, extension, hook, layout, widget
from libqtile.command import lazy
from libqtile.config import Drag, Group, Key, Screen, Match

# mod4 or mod=super key
mod = "mod4"
mod1 = "alt"
mod2 = "control"
home = os.path.expanduser('~')

GREY = "#222222"
DARK_GREY = "#111111"
BLUE = "#007fdf"
DARK_BLUE = "#002a4a"
ORANGE = "#dd6600"
DARK_ORANGE = "#371900"
RED = "#ff0000"


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
    # Key([mod], "space",
    #     lazy.spawn(home + '/.config/rofi/launchers/misc/launcher.sh')),
    Key([mod], "space", lazy.spawn("rofi -modi drun -show drun -show-icons")),
    Key([mod], "c", lazy.spawn('alacritty  -e cmus')),
    # SUPER + SHIFT KEYS
    Key([mod, "shift"], "Return", lazy.spawn('thunar')),
    Key([mod, "shift"], "r", lazy.restart()),
    Key([mod, "shift"], "w", lazy.shutdown()),
    # CONTROL + ALT KEYS
    Key(["mod1", "control"], "r", lazy.spawn('rofi-theme-selector')),
    Key(["mod1", "control"], "u", lazy.spawn('pavucontrol')),
    Key(["mod1", "control"], "Return", lazy.spawn('alacritty')),
    # MOVE TO SCREEN
    Key([mod, "mod1"], "h", lazy.prev_screen()),
    Key([mod, "mod1"], "l", lazy.next_screen()),
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
    Key([mod, "control"], "h", lazy.layout.grow_left(),
        desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(),
        desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(),
        desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod, "mod1"], "f", lazy.layout.flip()),
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


def init_layout_theme():
    return {
        "margin": 0,
        "border_width": 2,
        "border_focus": BLUE,
        #        "border_normal": DARK_BLUE
        "border_normal": GREY

    }


layout_theme = init_layout_theme()
layouts = [
    layout.Columns(**layout_theme),
]


def color_separator(background, foreground):
    return widget.TextBox(
        text="",
        padding=-4,
        fontsize=34,
        background=background,
        foreground=foreground
    )


def init_widgets_list():
    bar = [
        widget.GroupBox(
            font="Ubuntu Nerd Font Mono Regula", fontsize=18,
            padding=4, borderwidth=1,
            urgent_border=DARK_BLUE,
            disable_drag=True, highlight_method="block",
            this_screen_border=DARK_BLUE, other_screen_border=DARK_ORANGE,
            this_current_screen_border=BLUE,
            other_current_screen_border=ORANGE),

        widget.TextBox(text="◤", fontsize=45, padding=-7, foreground=DARK_GREY,
                       background=GREY),

        widget.TaskList(borderwidth=0, highlight_method="block",
                        background=GREY,
                        border=DARK_GREY, urgent_border=DARK_BLUE,
                        markup_floating="<i>{}</i>",
                        markup_minimized="<s>{}</s>"),

        widget.Systray(background=GREY, foreground=DARK_GREY),
        widget.TextBox(text="◤", fontsize=45, padding=-7,
                       foreground=GREY, background=DARK_GREY),
        widget.PulseVolume(fmt=" {}", emoji=True, volume_app="pavucontrol"),
        widget.PulseVolume(volume_app="pavucontrol"),
        widget.Clock(
            format=" ⏱ %H:%M  <span color='#666'>%A %d-%m-%Y</span>  ")
    ]
    if os.path.isdir("/sys/module/battery"):
        bar.insert(-1,
                   widget.Battery(format=" {char} {percent:2.0%} ",
                                  charge_char="⚡", discharge_char="🔋",
                                  full_char="⚡", unknown_char="⚡",
                                  empty_char="⁉️ ", update_interval=2,
                                  show_short_text=False,
                                  default_text=""))
        bar.insert(-1,
                   widget.Battery(fmt="<span color='#666'>{}</span> ",
                                  format="{hour:d}:{min:02d}",
                                  update_interval=2, show_short_text=True,
                                  default_text=""))
    return bar


monitors = subprocess.run(
    r'xrandr | grep "\*" | cut -d" " -f4',
    shell=True,
    stdout=subprocess.PIPE
).stdout.decode("UTF-8").strip().split('\n')

screens = []

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

workspace = {
    "a":  ["Navigator", "Firefox",
           "navigator", "firefox", ],
    "s": ["QTCreator", "Brackets", "Code-oss", "Code", "Discord",
          "qtcreator", "brackets", "code-oss", "code", "discord"],
    "d": ["PacketTracer7"],
    "u": ["Inkscape", "inkscape", "Gimp", "gimp", "kdenlive"],
    "i": ["Zoom", "zoom", ],
    "o":  ["Thunar", "thunar", ],
    "p":  ["Evolution", "Geary", "Mail", "Thunderbird", "TelegramDesktop",
           "evolution", "geary", "mail", "thunderbird", "telegramDesktop"]
}


@hook.subscribe.client_new
def assign_app_group(client):
    wm_class = client.window.get_wm_class()[0]
    for i in range(len(workspace)):
        if wm_class in list(workspace.values())[i]:
            group = list(workspace.keys())[i]
            client.togroup(group)
            # I dont like to follow the window open in screen so i commnet it
            # client.group.cmd_toscreen()


main = None
follow_mouse_focus = False
bring_front_click = False
cursor_warp = False
floating_types = ["notification", "toolbar", "splash", "dialog", "utility"]
floating_layout = layout.Floating(float_rules=[
    *layout.Floating.default_float_rules,
    Match(wm_class='confirm'),
    Match(wm_class='dialog'),
    Match(wm_class='download'),
    Match(wm_class='error'),
    Match(wm_class='file_progress'),
    Match(wm_class='notification'),
    Match(wm_class='splash'),
    Match(wm_class='toolbar'),
    Match(wm_class='feh'),
    Match(wm_class='ssh-askpass'),
    Match(wm_class='gpick'),
    Match(wm_class='zoom'),
    Match(wm_class='confirmreset'),
    Match(wm_class='makebranch'),
    Match(wm_class='maketag'),
    Match(wm_class='Arandr'),
    Match(wm_class='Galculator'),
    Match(wm_class='flameshot'),
    Match(wm_class='pavucontrol'),
    Match(wm_class='xfce4-terminal'),
    Match(wm_class='xfce4-screenshooter'),
    Match(title='Open File'),
    Match(title='branchdialog'),
    Match(title='pinentry'),
],  fullscreen_border_width=0, border_width=0)
auto_fullscreen = True
focus_on_window_activation = "smart"  # smart or focus
widget_defaults = {
    "font": "Ubuntu Nerd Font Mono Regular",
    "fontsize": 12,
    "padding": 2,
}
wmname = "LG3D"


@hook.subscribe.startup_once
def start_once():
    global home
    subprocess.call([home + '/.config/scripts/autostart.sh'])
