#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
# script-install.sh — post-installation setup for Arch-based distros.
#
# Two phases:
#   • ROOT phase : microcode, GPU drivers, Bluetooth, base packages.
#   • USER phase : AUR helper (paru), CLI tools, GUI + Hyprland, configs.
#
# The script re-execs itself as the invoking user for the USER phase.
# ═══════════════════════════════════════════════════════════════
set -euo pipefail

PATH_DIR=$(dirname "$(readlink -f "$0")")

# ── Logging helpers ────────────────────────────────────────────
c_green="\e[0;32m\033[1m"
c_red="\e[0;31m\033[1m"
c_yellow="\e[0;33m\033[1m"
c_cyan="\e[0;36m\033[1m"
c_end="\033[0m\e[0m"

info()  { echo -e "${c_yellow}==> $*${c_end}"; }
ok()    { echo -e "${c_green}==> $*${c_end}"; }
err()   { echo -e "${c_red}==> $*${c_end}" >&2; }
ask()   { read -r -p "$(echo -e "${c_cyan}$* ${c_end}")" REPLY; }

# Install packages with pacman (root phase), idempotent.
pac() { pacman -S --noconfirm --needed "$@"; }

# ── Root-phase installers ──────────────────────────────────────
install_cpu_microcode() {
  local vendor
  vendor=$(lscpu | grep "Vendor ID" || true)

  if echo "$vendor" | grep -qi "intel"; then
    info "Installing Intel microcode..."
    pac intel-ucode
  elif echo "$vendor" | grep -qi "amd"; then
    info "Installing AMD microcode..."
    pac amd-ucode
  fi
}

install_gpu_drivers() {
  info "Detecting GPU..."
  local gpu
  gpu=$(lspci | grep -E "VGA|3D" || true)
  echo "GPU detected:"
  echo "$gpu"

  if echo "$gpu" | grep -qi "nvidia"; then
    if echo "$gpu" | grep -qi "intel"; then
      info "Hybrid GPU detected (Optimus)"
      pac nvidia nvidia-utils nvidia-prime lib32-nvidia-utils
      pac switcheroo-control
      systemctl enable --now switcheroo-control
    else
      info "Installing NVIDIA drivers..."
      pac nvidia nvidia-utils lib32-nvidia-utils
    fi
  elif echo "$gpu" | grep -qi "amd\|ati"; then
    info "Installing AMD drivers..."
    pac mesa vulkan-radeon lib32-vulkan-radeon
  elif echo "$gpu" | grep -qi "intel"; then
    info "Installing Intel drivers..."
    pac mesa vulkan-intel lib32-vulkan-intel
  else
    info "Unknown GPU, installing generic drivers..."
    pac mesa
  fi
}

install_bluetooth() {
  info "Detecting Bluetooth hardware..."
  if dmesg | grep -qi bluetooth; then
    info "Bluetooth detected. Installing stack..."
    pac bluez bluez-utils blueman
    systemctl enable --now bluetooth.service

    mkdir -p /etc/bluetooth
    cat > /etc/bluetooth/main.conf <<'EOF'
[Policy]
AutoEnable=true
EOF
    systemctl restart bluetooth.service
    ok "Bluetooth enabled"
  else
    info "No Bluetooth hardware detected, skipping..."
  fi
}

# ═══════════════════════ ROOT PHASE ═══════════════════════════
if [[ $EUID -eq 0 && "${1:-}" != "--user" ]]; then
  ok "Installation begin (ROOT)..."

  USER_NAME="${SUDO_USER:?Run this script with sudo, not as the root user directly}"

  pacman -Syu --noconfirm

  install_cpu_microcode
  install_gpu_drivers
  install_bluetooth

  info "Installing base packages..."
  pac git base-devel networkmanager udisks2 curl fish \
      pipewire wireplumber pipewire-pulse pipewire-jack pipewire-audio

  systemctl enable --now NetworkManager

  # Hand off to the user phase, forwarding the target user.
  exec sudo -u "$USER_NAME" -H KIRO_TARGET_USER="$USER_NAME" "$0" --user
fi

# ═══════════════════════ USER PHASE ═══════════════════════════
if [[ "${1:-}" == "--user" ]]; then
  ok "User setup..."

  USER_NAME="${KIRO_TARGET_USER:-$USER}"
  USER_HOME="$HOME"

  # -------- paru (AUR helper) --------
  if ! command -v paru &>/dev/null; then
    info "Bootstrapping paru..."
    tmp_paru=$(mktemp -d)
    git clone https://aur.archlinux.org/paru.git "$tmp_paru"
    ( cd "$tmp_paru" && makepkg -si --noconfirm )
    rm -rf "$tmp_paru"
  fi

  info "Installing CLI tools and fonts..."
  paru -S --noconfirm --needed \
    fish starship \
    ripgrep fzf jq bat playerctl \
    ttf-jetbrains-mono-nerd noto-fonts-emoji

  info "Changing default shell to fish..."
  chsh -s /usr/bin/fish

  # -------- GUI + Hyprland --------
  ask "Would you like to install the GUI (Hyprland)? [y/N]"
  case "$REPLY" in
    [yY])
      info "Installing GUI base packages..."
      paru -S --noconfirm --needed \
        adapta-gtk-theme pavucontrol kitty \
        nerd-fonts-jetbrains-mono nerd-fonts-ubuntu-mono \
        nm-connection-editor ttf-material-design-icons-git thunar \
        thunar-archive-plugin blueman \
        gvfs gvfs-mtp

      info "Installing Hyprland setup..."
      # shellcheck source=installation_folder/hyper_install.sh
      source "$PATH_DIR/installation_folder/hyper_install.sh"
      install_hyper "$PATH_DIR" "$USER_HOME" "$USER_NAME"
      ;;
  esac

  # -------- RAM optimization --------
  ask "Optimize RAM usage (zram + swapfile)? [y/N]"
  case "$REPLY" in
    [yY])
      # ram_opt.sh needs root; run it via sudo.
      sudo bash "$PATH_DIR/installation_folder/ram_opt.sh"
      ;;
  esac

  # -------- Configs --------
  info "Copying configs..."
  mkdir -p "$HOME/.config"
  cp -Rf "$PATH_DIR/config/." "$HOME/.config/"
  cp "$PATH_DIR/.tmux.conf" "$HOME/" || true

  # -------- AstroNvim --------
  info "Installing AstroNvim..."
  if [ -d "$HOME/.config/nvim" ]; then
    mv "$HOME/.config/nvim" "$HOME/.config/nvim_backup_$(date +%s)"
  fi
  git clone --depth 1 https://github.com/AstroNvim/AstroNvim "$HOME/.config/nvim"
  nvim --headless "+Lazy! sync" +qa

  fc-cache -fv

  ok "Installation finished 🚀"
fi
