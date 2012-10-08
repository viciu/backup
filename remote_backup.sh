#!/bin/bash

# @author Wiktor Kolodziej [wiktor zhr.pl]
# NOTE: this assumes ssh keys to be installed on target machine
# in this version only current dir is copied to remote machine

SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#read BACKUP_DIRS from external file depending on hostname -s
. /root/utils/backup/backup_dirs.`hostname -s`

#read TARGET var
. /root/utils/backup/backup_target.`hostname -s`

for i in $BACKUP_DIRS
do
    rsync -avz -e ssh --delete --acls --owner --group --executability -R $i $TARGET
done

echo "remote_backup.sh: "$(date) >> /var/log/xutils.log

