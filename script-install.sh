#!/usr/bin/env bash
set -euo pipefail

PATH_DIR=$(dirname "$(readlink -f "$0")")

greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
yellowColour="\e[0;33m\033[1m"
turquoiseColour="\e[0;36m\033[1m"

install_cpu_microcode() {
  CPU_VENDOR=$(lscpu | grep "Vendor ID")

  if echo "$CPU_VENDOR" | grep -qi "intel"; then
    echo "Installing Intel microcode..."
    pacman -S --noconfirm --needed intel-ucode
  elif echo "$CPU_VENDOR" | grep -qi "amd"; then
    echo "Installing AMD microcode..."
    pacman -S --noconfirm --needed amd-ucode
  fi
}

install_gpu_drivers() {

  echo "Detecting GPU..."
  GPU_INFO=$(lspci | grep -E "VGA|3D")

  echo "GPU detected:"
  echo "$GPU_INFO"

  # ---------- NVIDIA ----------
  if echo "$GPU_INFO" | grep -qi "nvidia"; then

    if echo "$GPU_INFO" | grep -qi "intel"; then
      echo "Hybrid GPU detected (Optimus)"

      pacman -S --noconfirm --needed \
        nvidia nvidia-utils nvidia-prime \
        lib32-nvidia-utils

      # opción más moderna
      pacman -S --noconfirm --needed switcheroo-control
      systemctl enable --now switcheroo-control

    else
      echo "Installing NVIDIA drivers..."

      pacman -S --noconfirm --needed \
        nvidia nvidia-utils \
        lib32-nvidia-utils
    fi

  # ---------- AMD ----------
  elif echo "$GPU_INFO" | grep -qi "amd\|ati"; then
    echo "Installing AMD drivers..."

    pacman -S --noconfirm --needed \
      mesa vulkan-radeon lib32-vulkan-radeon

  # ---------- Intel ----------
  elif echo "$GPU_INFO" | grep -qi "intel"; then
    echo "Installing Intel drivers..."

    pacman -S --noconfirm --needed \
      mesa vulkan-intel lib32-vulkan-intel

  # ---------- Fallback ----------
  else
    echo "Unknown GPU, installing generic drivers..."

    pacman -S --noconfirm --needed mesa
  fi
}


install_bluetooth() {
  echo "Detecting Bluetooth hardware..."

  if dmesg | grep -qi bluetooth; then
    echo "Bluetooth detected. Installing stack..."

    pacman -S --noconfirm --needed \
      bluez bluez-utils blueman

    systemctl enable --now bluetooth.service

    # opcional: habilitar auto power-on
    mkdir -p /etc/bluetooth
    cat > /etc/bluetooth/main.conf <<EOF
[Policy]
AutoEnable=true
EOF

    systemctl restart bluetooth.service

    echo "Bluetooth enabled ✔"
  else
    echo "No Bluetooth hardware detected, skipping..."
  fi
}


# ---------------- ROOT PHASE ----------------
if [[ $EUID -eq 0 && "${1:-}" != "--user" ]]; then
  echo -e "${greenColour}Installation Begin (ROOT)...${endColour}"

  USER_NAME="$SUDO_USER"
  USER_HOME=$(eval echo ~"$USER_NAME")

  pacman -Syu --noconfirm

  install_cpu_microcode 
  install_gpu_drivers
  install_bluetooth

  echo -e "${yellowColour}Installing base packages...${endColour}"
  pacman -S --noconfirm --needed \
    git base-devel networkmanager udisks2 \
    curl fish \
    pipewire wireplumber pipewire-pulse pipewire-jack pipewire-audio

  systemctl enable --now NetworkManager


  # 👉 pasar a fase usuario
  exec sudo -u "$USER_NAME" -H "$0" --user
fi

# ---------------- USER PHASE ----------------
if [[ "${1:-}" == "--user" ]]; then
  echo -e "${greenColour}User setup...${endColour}"

  USER_HOME="$HOME"

  # -------- paru --------
  if ! command -v paru &>/dev/null; then
    git clone https://aur.archlinux.org/paru.git "$HOME/paru"
    cd "$HOME/paru"
    makepkg -si --noconfirm || exit 1
  fi

  echo -e "${yellowColour}Installing packages...${endColour}"
  paru -S --noconfirm --needed \
    fish starship \
    ripgrep fzf jq bat playerctl \
    ttf-jetbrains-mono-nerd noto-fonts-emoji


  echo "Changing shell..."
  chsh -s /usr/bin/fish

  # -------- GUI --------
  read -p "$(echo -e ${turquoiseColour}Would You like install GUI? y/n ${endColour})" opt

  case $opt in
    [yY] )
      paru -S --noconfirm \
        adapta-gtk-theme pavucontrol kitty \
        nerd-fonts-jetbrains-mono nerd-fonts-ubuntu-mono \
        nm-connection-editor ttf-material-design-icons-git thunar \
        thunar-archive-plugin blueman pulseaudio-control \
        gvfs gvfs-mtp

      echo -e "Choose your WM Setup${redColour}"
      echo "1.- qTile"
      echo "2.- i3"
      echo -e "3.- hyprland${endColour}"

      read -p "Select your option " opt

      case $opt in
        1 )
          source "$PATH_DIR/installation_folder/qtile_install.sh"
          install_qtile "$PATH_DIR" "$USER_HOME" "${USER_NAME}"
          ;;
        2 )
          source "$PATH_DIR/installation_folder/i3_install.sh"
          install_i3 "$PATH_DIR" "$USER_HOME" "${USER_NAME}"
          ;;
        3 )
          source "$PATH_DIR/installation_folder/hyper_install.sh"
          install_hyper "$PATH_DIR" "$USER_HOME" "${USER_NAME}"
          ;;
        * )
          echo -e "${redColour}Invalid option, skipping WM installation.${endColour}"
          ;;
      esac
      ;;
  esac

  # -------- RAM OPT --------
  read -p "Optimize RAM usage? (y/n) " opt

  case $opt in
    [yY] )
      source "$PATH_DIR/installation_folder/ram_opt.sh"
      ;;
  esac

  # -------- CONFIGS --------
  echo -e "${yellowColour}Copying configs...${endColour}"

  mkdir -p "$HOME/.config"
  cp -Rf "$PATH_DIR/config/." "$HOME/.config/"
  cp "$PATH_DIR/.tmux.conf" "$HOME/" || true

  # -------- NVIM --------
  echo -e "${yellowColour}Installing AstroNvim...${endColour}"

  if [ -d "$HOME/.config/nvim" ]; then
    mv "$HOME/.config/nvim" "$HOME/.config/nvim_backup_$(date +%s)"
  fi

  git clone --depth 1 https://github.com/AstroNvim/AstroNvim "$HOME/.config/nvim"

  nvim --headless "+Lazy! sync" +qa

  echo -e "${greenColour}AstroNvim installation complete!${endColour}"

  fc-cache -fv

  echo -e "${greenColour}Installation Finished 🚀${endColour}"
fi
