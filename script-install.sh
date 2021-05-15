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

echo -e "${greenColour}Installation Begin...${endColour}"
echo $PATH_DIR
echo $USER_HOME

# sudo pacman -Sy --noconfirm  archlinux-keyring 
sudo pacman -Syu --noconfirm

echo -e "${yellowColour}Installing packages... ${endColour}"
sudo pacman -S --noconfirm git

git clone https://aur.archlinux.org/trizen-git.git
cd "$PATH_DIR/trizen-git"
makepkg -si

trizen -S --noedit --noconfirm zsh  \
python gvfs gvfs-mtp \
gzip alacritty-ligatures \
networkmanager \
htop tlp tmux ufw  udisks2 \
pulseaudio noto-fonts noto-fonts-cjk ttf-font-awesome \
neofetcht tf-nerd-fonts-symbols xclip powerline-fonts \
python-psutil pip wget playerctl neovim-git \
crda  ranger ueberzug atool ripgrep \
uctags-git nodejs-lts-fermiu yarn

echo "${turquoiseColour}Would You like install GUI? y/n"
read -p "" opt
case $opt in 
    [yY]* )
        trizen -S --noedit --noconfirm xorg xfce4-taskmanager adapta-gtk-theme \
        pavucontrol polkit firefox polkit-gnome redshift vlc lxappearance rofi \
        flameshot lightdm lightdm-gtk-greeter thunar thunar-archive-plugin \
        dunst ristretto picom-jonaburg-git blight udiskie mupdf bat zathura \
        zathura-pdf-mupdf

        echo "Choose your WM Setup${redColour}"
        echo "1.- [q]tile"
        echo "2.- [i]3${endColour}"

        read -p "" opt
        case $opt in
            [qQ]* ) 
                source "$PATH_DIR/installation_folder/qtile_install.sh"
                install_qtile $PATH_DIR $USER_HOME
                echo "${greenColour}Installation Succesful";;
            [iI]* )
                source "$PATH_DIR/installation_folder/i3_install.sh"
                install_i3 $PATH_DIR $USER_HOME
                echo "${greenColour}Installation Succesful";;
        esac
esac


git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
git clone https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

echo "${yellowColour}Installing Common Packages${endColour}"
cp -R "$PATH_DIR/config/" "$USER_HOME/.config/"
cp "$PATH_DIR/.tmux.conf" "$USER_HOME/"
cp "$PATH_DIR/.zshrc" "$USER_HOME/"
cp "$PATH_DIR/.bashrc" "$USER_HOME/"
cp "$PATH_DIR/.p10k.zsh" "$USER_HOME/"

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "${redColour}Remeber do :PlugInstall at start nvim${endColour}"
sleep 3

echo "${turquoiseColour}All common packages and config files have been installed"

pip install --user neovim
pip install --user jedi

sudo systemctl enable lightdm
sudo systemctl enable NetworkManager
sudo systemctl enable ufw
sudo systemctl enable tlp
sudo systemctl enable bluetooth.service

mkdir -p /etc/X11/xorg.conf.d && sudo tee <<'EOF' /etc/X11/xorg.conf.d/90-touchpad.conf 1> /dev/null
Section "InputClass"
        Identifier "touchpad"
        MatchIsTouchpad "on"
        Driver "libinput"
        Option "Tapping" "on"
EndSection
EOF

