#!/bin/bash

echo "Create your .passwd and .admin files"
echo ".passwd is needed for mysql backup, .admin fill with your email address"
echo ""

mkdir -p /backup/mysql
mkdir -p /backup/pgsql
mkdir -p /backup/archive
mkdir -p /backup/current
mkdir -p /backup/integrity/archive
cp backup.dirs_example backup.dirs_`hostname -s`

#	ln -s /root/utils/backup.sh /etc/cron.daily/backup.sh
#	ln -s /root/utils/gziper.sh /etc/cron.weekly/gziper.sh
#	ln -s /root/utils/flusher.sh /etc/cron.weekly/flusher.sh

cat <<EOF
#please add this to your crontab
45 02 * * * /root/utils/backup/integrity.sh 1>>/dev/null 2>>/dev/null
00 03 * * * /root/utils/backup/backup.sh 1>>/var/log/xutils.log 2>>/var/log/xutils.log
13 03 * * 7 /root/utils/backup/gziper.sh 1>>/var/log/xutils.log 2>>/var/log/xutils.log
43 03 * * 7 /root/utils/backup/flusher.sh 1>>/var/log/xutils.log 2>>/var/log/xutils.log
04 04 * * * /root/utils/backup/remote_backup.sh 1>>/var/log/xutils.log 2>>/var/log/xutils.log
EOF


