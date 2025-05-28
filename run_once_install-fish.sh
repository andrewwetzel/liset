#!/usr/bin/env bash
set -e

install_fish_apt() { … }              # keep your existing install code

# 1) install fish if missing
if ! command -v fish >/dev/null; then
  if   command -v apt-get >/dev/null;   then install_fish_apt
  elif command -v dnf   >/dev/null;     then sudo dnf  -y install fish
  elif command -v pacman >/dev/null;    then sudo pacman -Sy --noconfirm fish
  else
    echo "No known package manager found—install fish yourself." >&2
    exit 1
  fi
fi

fish_path="$(command -v fish)"

# 2) ensure fish is listed in /etc/shells
grep -qxF "$fish_path" /etc/shells || echo "$fish_path" | sudo tee -a /etc/shells >/dev/null

# 3) switch THIS user only if we’re not already on fish
current_shell="$(getent passwd "$USER" | cut -d: -f7)"
if [ "$current_shell" != "$fish_path" ]; then
  sudo chsh -s "$fish_path" "$USER"
fi

# 4) drop into fish if we’re still in another shell
[ "$SHELL" != "$fish_path" ] && setsid "$fish_path" -l </dev/null &>/dev/null &
