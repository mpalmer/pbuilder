#!/bin/sh
# example file to be used with --hookdir
#
# work around initscripts postinst which mounts /sys with cdebootstrap.
# Bug: #350262

set +e

umount /sys
umount /proc/bus/usb
umount /dev/shm
umount /proc
umount /dev/pts

exit 0;
