#!/bin/bash

# Commands
CMD_WITH_SUDO="sudo bash -c "$(curl -sSL https://raw.githubusercontent.com/FootGod-bot/Nas-Auto-Mount/main/automount.sh)""        # Command if sudo exists
CMD_NO_SUDO="bash -c "$(curl -sSL https://raw.githubusercontent.com/FootGod-bot/Nas-Auto-Mount/main/automount_root.sh)""  # Fallback

# Detect sudo
if command -v sudo &> /dev/null; then
    $CMD_WITH_SUDO
else
    $CMD_NO_SUDO
fi
