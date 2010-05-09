#!/bin/bash

FILE_NAME=$(date +'%Y-%m-%d').sql
/usr/bin/mysqldump -u root --password=`cat /root/utils/backup/.passwd` \
                   --all-databases --add-drop-table --add-locks > /backup/mysql/${FILE_NAME}
gzip /backup/mysql/${FILE_NAME}
