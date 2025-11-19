#!/bin/bash

# ---- Step 0: Install requirements ----
echo "Installing required packages..."
sudo apt update
sudo apt install -y cifs-utils smbclient

# ---- Step 1: Ask user for NAS info ----
read -p "Enter NAS IP (e.g., 192.168.1.118): " NAS_IP
read -p "Enter NAS share name (e.g., movies): " NAS_SHARE
read -p "Enter local mount point (e.g., /media/Movies): " MOUNT_POINT

read -p "Enter NAS username: " NAS_USER
read -sp "Enter NAS password: " NAS_PASS
echo

NAS="//${NAS_IP}/${NAS_SHARE}"

# ---- Step 2: Create mount point ----
[ ! -d "$MOUNT_POINT" ] && sudo mkdir -p "$MOUNT_POINT"

# ---- Step 3: Mount the share ----
if mountpoint -q "$MOUNT_POINT"; then
    echo "$MOUNT_POINT is already mounted."
else
    sudo mount -t cifs "$NAS" "$MOUNT_POINT" \
      -o username="$NAS_USER",password="$NAS_PASS",vers=3.0,uid=$(id -u),gid=$(id -g)
    if [ $? -eq 0 ]; then
        echo "Mounted $NAS at $MOUNT_POINT"
    else
        echo "Failed to mount $NAS"
        exit 1
    fi
fi

# ---- Step 4: Ask to add to fstab ----
echo "Listing items in the folder"
ls "$MOUNT_POINT"
echo "If you did not see the files there that you want to see, press Ctrl+C."
read -p "Do you want to add this mount to /etc/fstab for auto-mount? (y/n): " ADD_FSTAB

if [[ "$ADD_FSTAB" =~ ^[Yy]$ ]]; then
    # Create a credentials file
    CRED_FILE="$HOME/.nas_credentials"
    echo "username=$NAS_USER" > "$CRED_FILE"
    echo "password=$NAS_PASS" >> "$CRED_FILE"
    chmod 600 "$CRED_FILE"

    FSTAB_LINE="${NAS} ${MOUNT_POINT} cifs credentials=${CRED_FILE},vers=3.0,uid=$(id -u),gid=$(id -g) 0 0"
    echo "$FSTAB_LINE" | sudo tee -a /etc/fstab
    echo "Added to /etc/fstab using a secure credentials file. You can test with: sudo mount -a"
fi

echo "Done!"
