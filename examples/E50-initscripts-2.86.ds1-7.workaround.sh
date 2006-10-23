#!/bin/sh
# example file to be used with --hookdir
#
# work around initscripts postinst which mounts /sys etc.
# Bug: #344089

set +e

umount /sys
umount /run
umount /proc/bus/usb
umount /dev/shm

# work around initscripts postinst which mount /lib/init/rw
# Bug: #392136, #390126
umount /lib/init/rw

# inetd seems to be dually started after upgrade, kill it.
# Bug: #262627
kill -9 $(cat /var/run/inetd.pid)

exit 0
