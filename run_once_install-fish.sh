#!/usr/bin/env bash
set -e

# 1) install fish if missing
if ! command -v fish >/dev/null; then
  if command -v apt-get >/dev/null;   then sudo apt-get update -qq && sudo apt-get install -y fish
  elif command -v dnf >/dev/null;     then sudo dnf -y install fish
  elif command -v pacman >/dev/null;  then sudo pacman -Sy --noconfirm fish
  else
    echo "No known package manager found—install fish yourself." >&2
    exit 1
  fi
fi

fish_path="$(command -v fish)"

# 2) ensure fish is an allowed login shell
grep -qxF "$fish_path" /etc/shells || echo "$fish_path" | sudo tee -a /etc/shells >/dev/null

# 3) set fish as the login shell for this user
chsh -s "$fish_path" "$USER"

# 4) jump straight into fish unless we're already there
if [ "$SHELL" != "$fish_path" ]; then
  echo "Switching to fish…"
  exec "$fish_path" -l   # -l = login shell
fi
