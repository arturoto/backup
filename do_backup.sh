#!/bin/sh
#
# Backup script for Project #1 machines.
#

PATH=/usr/sbin:/sbin:/usr/bin:/bin
export PATH

#
# Mount the partition backups should be written to
#

dumphost=$(hostname)
echo "Backups for $dumphost"

if [ ! -d "/backups" ]; then
mkdir /backups > /dev/null 2>&1
retval=$?
if [ $retval -ne 0 ]; then
echo "Unable to create /backups"
exit 1
fi
fi

if [ ! -f "/backups/BACKUP_PARTITION" ]; then
mount toaster:/vol/backups /backups > /dev/null 2>&1
retval=$?
if [ $retval -ne 0 ]; then
echo "Unable to mount backup partition"
exit 1
fi
fi
if [ ! -d "/backups/${dumphost}" ]; then
mkdir "/backups/${dumphost}" > /dev/null 2>&1
retval=$?
if [ $retval -ne 0 ]; then
echo "Unable to create /backups/${dumphost}"
exit 1
fi
fi

#
# Run dump(8) for each partition we want backed up.
#

dump -0af /backups/${dumphost}/root.dump /
dump -0af /backups/${dumphost}/boot.dump /boot
dump -0af /backups/${dumphost}/var.dump /var
dump -0af /backups/${dumphost}/usr.dump /usr
dump -0af /backups/${dumphost}/local.dump /local
dump -0af /backups/${dumphost}/home.dump /home

umount /backups
