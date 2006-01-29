#!/bin/sh
# work around initscripts postinst which mounts /sys with cdebootstrap.
# Bug: #350262

set +e

umount /sys
umount /run
umount /proc/bus/usb
umount /dev/shm

exit 0;
