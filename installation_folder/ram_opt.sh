#!/bin/bash


echo "===> Installing zram-generator (Arch package)"
pacman -S --noconfirm zram-generator

echo "===> Configuring zram"
install -Dm644 /dev/stdin /etc/systemd/zram-generator.conf <<'EOF'
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
swap-priority = 100
EOF

echo "===> Reloading systemd and enabling zram"
systemctl daemon-reexec
systemctl start systemd-zram-setup@zram0.service

echo "===> Creating secondary swapfile (8G)"
if [[ ! -f /swapfile ]]; then
  fallocate -l 8G /swapfile || dd if=/dev/zero of=/swapfile bs=1M count=8192 status=progress
  chmod 600 /swapfile
  mkswap /swapfile
else
  echo "Swapfile already exists, skipping creation"
fi

echo "===> Enabling swapfile"
swapon /swapfile || true

echo "===> Persisting swapfile in fstab"
if ! grep -q "^/swapfile" /etc/fstab; then
  echo "/swapfile none swap defaults,pri=10 0 0" >> /etc/fstab
fi

echo "===> Setting swappiness"
install -Dm644 /dev/stdin /etc/sysctl.d/99-swappiness.conf <<'EOF'
vm.swappiness=90
EOF

sysctl --system

echo "===> Final swap status"
swapon --show
free -h

echo "✅ Done. zram active + secondary swapfile configured (Arch style)."
