#!/usr/bin/env bash
set -e
if ! command -v sshpass >/dev/null; then
  if command -v apt-get >/dev/null;   then
      sudo env DEBIAN_FRONTEND=noninteractive \
        apt-get update -qq
      sudo env DEBIAN_FRONTEND=noninteractive \
        apt-get install -yq sshpass
  elif command -v dnf >/dev/null;     then sudo dnf -y install sshpass
  elif command -v pacman >/dev/null;  then sudo pacman -Sy --noconfirm sshpass
  fi
fi
