#!/bin/bash

# Ask for NAS info
read -p "Enter NAS address (e.g., 192.168.1.118): " NAS_IP
read -p "Enter NAS share name (e.g., movies): " NAS_SHARE
read -p "Enter local mount point (e.g., /media/Movies): " MOUNT_POINT

# Ask for credentials
read -p "Enter NAS username: " NAS_USER
read -sp "Enter NAS password: " NAS_PASS
echo

# Build full NAS path
NAS="//${NAS_IP}/${NAS_SHARE}"

# Create mount point if it doesn't exist
[ ! -d "$MOUNT_POINT" ] && mkdir -p "$MOUNT_POINT"

# Check if already mounted
if mountpoint -q "$MOUNT_POINT"; then
    echo "$MOUNT_POINT is already mounted."
else
    # Mount the NAS share
    sudo mount -t cifs "$NAS" "$MOUNT_POINT" \
      -o username="$NAS_USER",password="$NAS_PASS",vers=3.0,uid=$(id -u),gid=$(id -g)

    if [ $? -eq 0 ]; then
        echo "Mounted $NAS at $MOUNT_POINT"
    else
        echo "Failed to mount $NAS"
    fi
fi
