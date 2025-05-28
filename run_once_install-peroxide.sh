#!/usr/bin/env bash
set -e

install_peroxide() {
  # grab latest binary release, works on x86_64 glibc
  tmp=$(mktemp)
  curl -fsSL \
    https://github.com/0xGingi/peroxide/releases/latest/download/peroxide-linux-amd64 \
    -o "$tmp"
  sudo install -m 755 "$tmp" /usr/local/bin/peroxide
  rm -f "$tmp"
}

if ! command -v peroxide >/dev/null; then
  # deps: sshpass so peroxide can do password auth
  if command -v apt-get >/dev/null; then
    sudo env DEBIAN_FRONTEND=noninteractive \
      apt-get update -qq
    sudo env DEBIAN_FRONTEND=noninteractive \
      apt-get install -yq sshpass
  elif command -v dnf >/dev/null; then
    sudo dnf -y install sshpass
  elif command -v pacman >/dev/null; then
    sudo pacman -Sy --noconfirm sshpass
  fi
  install_peroxide
fi
