# #!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "❌ Run this script as root"
  exit 1
fi

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

# pacman -Sy --noconfirm  archlinux-keyring
pacman -Syu --noconfirm

echo -e "${yellowColour}Installing packages... ${endColour}"
pacman -S --noconfirm git base-devel

git clone https://aur.archlinux.org/yay-bin.git
cd "$PATH_DIR/yay-bin"
makepkg -si

yay -S  \
zsh-theme-powerlevel10k zsh oh-my-zsh-git \
python gvfs gvfs-mtp gzip alacritty-ligatures \
networkmanager bashtop tlp tmux ufw  udisks2 \
pulseaudio noto-fonts noto-fonts-cjk ttf-font-awesome \
neofetch ttf-nerd-fonts-symbols  powerline-fonts \
python-psutil python-pip wget playerctl neovim-git \
crda  ranger ueberzug atool ripgrep fzf \
uctags-git nodejs-lts-fermium jq gitui \
pamixer lsb_release ncmpcpp bat neovim ripgrep sed ufw \

chsh -s $(which zsh)
read -p "${turquoiseColour}Would You like install GUI? y/n " opt

case $opt in 
    [yY] )
        yay -S adapta-gtk-theme pavucontrol \
        polkit polkit-gnome redshift lxappearance rofi \
        flameshot lightdm lightdm-gtk-greeter \
        dunst feh picom-jonaburg-git blight udiskie mupdf zathura \
        zathura-pdf-mupdfpowerlevel10k qt5ct\
        xclip nerd-fonts-jetbrains-mono nerd-fonts-ubuntu-mono \
        nm-connection-editor arandr zathura-pdf-mupdf \
        ttf-material-design-icons-git xfce4-settings thunar \
        thunar-archive-plugin blueman

        echo "Choose your WM Setup${redColour}"
        echo "1.- qTile"
        echo "2.- i3${endColour}"
        read -p "Enter 1 or 2: " opt

        case $opt in
            1 )
                source "$PATH_DIR/installation_folder/qtile_install.sh"
                install_qtile $PATH_DIR $USER_HOME
                echo "${greenColour}Installation Successful${endColour}"
                ;;
            2 )
                source "$PATH_DIR/installation_folder/i3_install.sh"
                install_i3 $PATH_DIR $USER_HOME
                echo "${greenColour}Installation Successful${endColour}"
                ;;
            * )
                echo "${redColour}Invalid option, skipping WM installation.${endColour}"
                ;;
        esac


echo "Would you like to optimize your system for RAM usage? (y/n)"
read -p "" opt

case $opt in
    [yY] )
        source "$PATH_DIR/installation_folder/ram_opt.sh"
        echo "${greenColour}RAM optimization completed.${endColour}"
        ;;
    [nN] )
        echo "Skipping RAM optimization."
        ;;
esac


echo "${yellowColour}Installing AstroNvim...${endColour}"

# Backup existing nvim config if it exists
if [ -d "$USER_HOME/.config/nvim" ]; then
    echo "Backing up existing Neovim config to nvim_backup_$(date +%s)"
    mv "$USER_HOME/.config/nvim" "$USER_HOME/.config/nvim_backup_$(date +%s)"
fi

# Clone AstroNvim
git clone --depth 1 https://github.com/AstroNvim/AstroNvim "$USER_HOME/.config/nvim"

# Install AstroNvim plugins
nvim --headless +PackerSync +qall

echo "${greenColour}AstroNvim installation complete!${endColour}"


git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons

echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

echo "${yellowColour}Installing Common Packages${endColour}"
cp -Rf "$PATH_DIR/config/*" "$USER_HOME/.config/"
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

npm i -g \
  import-sort-cli \
  import-sort-parser-babylon \
  import-sort-parser-typescript \
  import-sort-style-renke 

systemctl enable lightdm
systemctl enable NetworkManager
systemctl enable ufw
systemctl enable tlp
systemctl enable bluetooth.service

mkdir -p /etc/X11/xorg.conf.d && tee <<'EOF' /etc/X11/xorg.conf.d/90-touchpad.conf 1> /dev/null
Section "InputClass"
        Identifier "touchpad"
        MatchIsTouchpad "on"
        Driver "libinput"
        Option "Tapping" "on"
EndSection
EOF
