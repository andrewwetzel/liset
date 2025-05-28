#!/usr/bin/env bash
set -e

install_fish_apt() {
  # no questions, no TUI
  sudo env \
    DEBIAN_FRONTEND=noninteractive \
    NEEDRESTART_MODE=a \            # auto-restart daemons
    NEEDRESTART_SVC=1 \             # don’t ask which ones
    apt-get update -qq
  sudo env \
    DEBIAN_FRONTEND=noninteractive \
    NEEDRESTART_MODE=a \
    NEEDRESTART_SVC=1 \
    apt-get install -yq fish
}

if ! command -v fish >/dev/null; then
  if   command -v apt-get >/dev/null;   then install_fish_apt
  elif command -v dnf >/dev/null;       then sudo dnf -y install fish
  elif command -v pacman >/dev/null;    then sudo pacman -Sy --noconfirm fish
  else
    echo "No known package manager found—install fish yourself." >&2
    exit 1
  fi
fi

fish_path="$(command -v fish)"
grep -qxF "$fish_path" /etc/shells || echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
chsh -s "$fish_path" "$USER"

[ "$SHELL" != "$fish_path" ] && exec "$fish_path" -l
