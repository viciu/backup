#!/bin/bash

# @author Wiktor Kolodziej [wiktor zhr.pl]

SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#read BACKUP_DIRS from external file depending on hostname -s
. /root/utils/backup/backup_dirs.`hostname -s`

for i in $BACKUP_DIRS
do
    rsync -av --delete --acls --owner --group --executability -R $i /backup/current
done

which mysqldump
if [ $? -eq 0 ]
then
    bash /root/utils/backup/mysqldump.sh
fi

echo "backup.sh: "$(date) >> /var/log/xutils.log

