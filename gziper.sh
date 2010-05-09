#!/bin/bash

# @author Wiktor Kolodziej [wiktor zhr.pl]

SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# check if backup already exists
if [ -d /backup/archive/$(date +'%Y-%m-%d') ]
then
    echo "Error! Backup dir exists"
#    exit 1
else
    mkdir /backup/archive/$(date +'%Y-%m-%d')
fi



for i in `/bin/ls /backup/current`
do
    echo $i
    # cvfj for bzip2
    tar -cvzf /backup/archive/$(date +'%Y-%m-%d')/$i.tar.gz  /backup/current/$i/ &> /dev/null
#    rsync -av --delete -R $i /backup/current
done

echo "gziper.sh: "$(date) >> /var/log/xutils.log

#echo $(date +'%Y-%m-%d')
#find 20071113 -type f -ctime -15
#find 20071113 -type f -ctime -1 -exec ls -al {} \;
