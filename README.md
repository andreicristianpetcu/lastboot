lastboot
========
This is a small project that creates a rsync clone in /mnt/lastboot of everything in the root partition / excluding directories that are virtual like /dev or /proc and non "dotfiles" in the user's home directories.
This script is based on the rsync backup wiki page from the [Arch Linux Wiki](https://wiki.archlinux.org/index.php/Full_System_Backup_with_rsync)

build_links_test.sh creates a list of files and directories with hard and soft links. I use it test parameter changes.
savesynch.rb does the actual backup.

This script does not work yet.
