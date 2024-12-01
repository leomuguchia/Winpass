### How to Replace Utilman.exe with cmd.exe to Reset Windows Password

## Requirements:

    A Linux live USB or system (e.g., Parrot OS)
    Access to the Windows partition containing Utilman.exe

## Steps:
1. Mount the Windows Partition

First, identify the correct partition (e.g., /dev/sdc2) and mount it as read-write:

`sudo mkdir -p /media/lioo/1212FCAD12FC96C7`
`sudo mount -o rw /dev/sdc2 /media/lioo/1212FCAD12FC96C7`

2. Backup the Original Utilman.exe

To avoid losing the original file, rename it:

`sudo mv /media/lioo/1212FCAD12FC96C7/Windows/System32/Utilman.exe /media/lioo/1212FCAD12FC96C7/Windows/System32/Utilman.bak`

3. Replace Utilman.exe with cmd.exe

Copy cmd.exe to Utilman.exe:

`sudo cp /media/lioo/1212FCAD12FC96C7/Windows/System32/cmd.exe /media/lioo/1212FCAD12FC96C7/Windows/System32/Utilman.exe`

4. Unmount the Partition

Unmount the partition cleanly:

`sudo umount /media/lioo/1212FCAD12FC96C7`

5. Reboot Into Windows

    Boot into Windows.
    Press Win + U (or click the Ease of Access icon) on the login screen. This should open cmd.exe instead of Utilman.exe.

6. Reset the Password (Optional)

To reset a password, use the following command in the command prompt:

net user <username> <newpassword>

Example:

`net user Administrator MyNewPassword123`

7. Restore the Original Utilman.exe (Optional)

Once done, it’s a good practice to restore Utilman.exe:

    Boot back into Linux.
    Mount the Windows partition again.
    Restore the original Utilman.exe:

    sudo mv /media/lioo/1212FCAD12FC96C7/Windows/System32/Utilman.bak /media/lioo/1212FCAD12FC96C7/Windows/System32/Utilman.exe

