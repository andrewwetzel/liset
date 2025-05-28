#!/usr/bin/env bash
set -e

install_fish_apt() {
  # fully non-interactive apt so needrestart never pops a dialog
  sudo env \
    DEBIAN_FRONTEND=noninteractive \
    NEEDRESTART_MODE=a \
    NEEDRESTART_SVC=1 \
    apt-get update -qq
  sudo env \
    DEBIAN_FRONTEND=noninteractive \
    NEEDRESTART_MODE=a \
    NEEDRESTART_SVC=1 \
    apt-get install -yq fish
}

# 1) install fish if it isn't already on the box
if ! command -v fish >/dev/null; then
  if   command -v apt-get >/dev/null;  then install_fish_apt
  elif command -v dnf >/dev/null;      then sudo dnf    -y install fish
  elif command -v pacman >/dev/null;   then sudo pacman -Sy --noconfirm fish
  else
    echo "No known package manager found—install fish yourself." >&2
    exit 1
  fi
fi

fish_path="$(command -v fish)"

# 2) ensure fish is in /etc/shells
grep -qxF "$fish_path" /etc/shells || echo "$fish_path" | sudo tee -a /etc/shells >/dev/null

# 3) switch this user **only if** the passwd entry isn't already fish
current_shell="$(getent passwd "$USER" | cut -d: -f7)"
if [ "$current_shell" != "$fish_path" ]; then
  sudo chsh -s "$fish_path" "$USER"
fi

# 4) if we're still inside bash, launch a detached login-fish so chezmoi can exit cleanly
[ "$SHELL" != "$fish_path" ] && setsid "$fish_path" -l </dev/null &>/dev/null &
