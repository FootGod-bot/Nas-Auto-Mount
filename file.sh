#!/bin/bash

# Commands
CMD_WITH_SUDO="sudo apt update"        # Command if sudo exists
CMD_NO_SUDO="echo 'No sudo available, running fallback command'"  # Fallback

# Detect sudo
if command -v sudo &> /dev/null; then
    $CMD_WITH_SUDO
else
    $CMD_NO_SUDO
fi
