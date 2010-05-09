#!/bin/bash

# @author Wiktor Kolodziej [wiktor zhr.pl]

SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#remove old backups (default 45 days for files, 90 days for mysql)
find /backup/archive/* -type d -mtime +45 -exec rm -r {} \;

find /backup/mysql/* -type f -mtime +90 -exec rm -r {} \;

#find 20071113 -type f -ctime -1 -exec ls -al {} \;

echo "flusher.sh: "$(date) >> /var/log/xutils.log