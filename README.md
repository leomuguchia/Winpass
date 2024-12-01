# WinPass

WinPass is a Bash script that allows users to replace `Utilman.exe` with `cmd.exe` on a Windows partition. This enables access to a command prompt session before logging into a Windows user account, which can help reset a forgotten password.

---

## Disclaimer
This script is intended for educational and recovery purposes only. It is not designed or intended for malicious use. Use this tool responsibly. The user is solely responsible for any actions taken using this script.

---

## Requirements
- A Linux live environment or Linux distribution.
- Access to the Windows partition that needs password recovery.
- Basic Linux command-line knowledge.

---

## How to Use
1. Clone the repository or download the script:
    ```bash
    git clone https://github.com/leomuguchia/Winpass.git
    cd WinPass
    ```

2. Make the script executable:
    ```bash
    chmod +x winpass.sh
    ```

3. Run the script as `root` or with `sudo`:
    ```bash
    sudo ./winpass.sh /dev/sdXY
    ```
   Replace `/dev/sdXY` with the correct identifier for your Windows partition.

---

## What It Does
1. Mounts the specified Windows partition.
2. Creates a backup of `Utilman.exe`.
3. Replaces `Utilman.exe` with `cmd.exe`.
4. Unmounts the partition.

After running the script, reboot into Windows and:
- Press `Win + U` (or click the Ease of Access icon) on the login screen to open a command prompt.
- Use the `net user` command to reset the password.

---

## Restoring the Original `Utilman.exe`
After resetting your password, it's good practice to restore the original `Utilman.exe` file. Use the same script to revert changes by following the steps provided in the script.

---

## License
This project is provided as-is and without warranty.
y