#!/usr/bin/env bash

PATH_DIR=$(dirname $(readlink -f "$0"))
USER_HOME=$(eval echo ~${SUDO_USER})

greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

if [ "$(id -u)" != 0 ]; then
        echo -e "${redColour}You are not admin user! Run as admin ${endColour}"
        exit
fi

echo -e "${greenColour}Installation Begin...${endColour}"
echo $PATH_DIR
echo $USER_HOME

sudo pacman -Sy --noconfirm  archlinux-keyring 
sudo pacman -Su

echo -e "${yellowColour}Installing packages... ${endColour}"
pacman -S --noconfirm git

git clone https://aur.archlinux.org/trizen.git
cd "$PATH_DIR/trizen"
makepkg -si

pacman -S --noconfirm \
qtile neovim xorg zsh xfce4-taskmanager \
python git adapta-gtk-theme \
pavucontrol firefox gvfs gvfs-mtp \
gzip alacritty adobe-source-code-pro-fonts \
adobe-source-han-sans-otc-fonts openssh npm \
networkmanager network-manager-applet yarn \
nodejs htop polkit polkit-gnome redshift tlp \
tmux ufw vlc udiskie udisks2 \
rofi pulseaudio picom noto-fonts noto-fonts-cjk \
neofetch lxappearance light lightdm lightdm-gtk-greeter \
thunar thunar-archive-plugin flameshot \
ttf-nerd-fonts-symbols xclip powerline-fonts \
dunst python-psutil pip \
ristretto wget

trizen -S --noconfirm zsh-theme-powerlevel10k-git \
oh-my-zsh-powerline-theme-git

echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

echo "${yellowColour}Installing nvim config${endColour}"
cp -R "$PATH_DIR/config/" "$USER_HOME/.config/"
cp "$PATH_DIR/.tmux.conf" "$USER_HOME/"
cp "$PATH_DIR/.bashrc" "$USER_HOME/"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "${redColour}Remeber do :PlugInstall at start nvim${endColour}"

pip install --user neovim
pip install --user jedi

systemctl enable lightdm
systemctl enable NetworkManager
systemctl enable ufw
systemctl enable tlp

mkdir -p /etc/X11/xorg.conf.d && sudo tee <<'EOF' /etc/X11/xorg.conf.d/90-touchpad.conf 1> /dev/null
Section "InputClass"
        Identifier "touchpad"
        MatchIsTouchpad "on"
        Driver "libinput"
        Option "Tapping" "on"
EndSection
EOF

