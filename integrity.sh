#!/bin/bash

##
# @author Wiktor Kolodziej [wiktor zhr.pl]
##

##
# This script checks for integrity problems on debian systems.
# It is divided into two parts:
# 1) debsums check (based on http://arthurdejong.org/recovery.html)
# 2) tripwire check (you need to have tripwire configured and installed on your box)
#
# To use it just review config section.
# Also, when you are sure that debsums produce false-positives, just
# add your filter to debsums_filter var.
##

############
# Config
############
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
ADMIN_EMAIL=`cat \`dirname $0\`/.admin`
LOG=/var/log/xutils.log
dirtomake="/backup/integrity/archive/$(date +'%Y-%m-%d')"
debsums_filter='
     grep -v "file /etc/"| grep -v "kernel-image" |
     grep -v "file /lib/lsb/init-functions" |
     grep -v "/lib/modules/2.6.26-2-xen"
'

############
# Functions
############

debsums_f() {
    cd /var/cache/apt/archives
    apt-get -y --download-only --reinstall install `debsums -l`
    debsums --generate=keep,nocheck *.deb
    debsums -s -a 2> /backup/integrity/broken.log
    sed -n 's/^.*checksum mismatch \([^ ]*\) file.*$/\1/p;s/^.*t open \([^ ]*\) file.*$/\1/p' < /backup/integrity/broken.log | sort -u > /backup/integrity/broken.pkgs
    mv /backup/integrity/broken.log $dirtomake
    mv /backup/integrity/broken.pkgs $dirtomake
}

prepare() {
    date >> ${LOG}
    echo "Integrity check started." >> ${LOG}
    mkdir $dirtomake
}

report_debsums() {
    if [ ! -e $dirtomake/broken.log ]
    then
        echo "No debsums report found" >> ${LOG}
        return
    fi

    cmd="$dirtomake/broken.log| ${debsums_filter}"

    if [ `eval "cat ${cmd}"|wc -l` != 0 ]
    then
        echo "Debug debsums"
        MSG="[DEBSUMS] Integrity violation found"
        echo ${MSG} >> ${LOG}
        eval "cat ${cmd}"| mail -s "${MSG}" ${ADMIN_EMAIL}
    fi
}


#todo if violations found send email
report_tripwire() {
    if [ ! -e $dirtomake/tripwire.log ]
    then
        echo "No tripwire report found" >> ${LOG}
        return
    fi

    if [ `cat $dirtomake/tripwire.log |grep "Total violations found:" |awk '{print $4}'` != 0 ]
    then
        echo "Debug tripwire"
        MSG="[TRIPWIRE] Integrity violation found"
        echo ${MSG} >> ${LOG}
        cat $dirtomake/tripwire.log | mail -s "${MSG}" ${ADMIN_EMAIL}
    fi
}

########## Debsums ######################
# prepare logs and report directory
prepare

# lauch debsums check
debsums_f

# report debsums check results to admin
report_debsums


######### Tripwire #######################
if [ ! -e /etc/tripwire/`hostname`-local.key ]
then
    echo "Tripwire not configured, exiting" >> ${LOG}
    exit
fi
tripwire --check > $dirtomake/tripwire.log
# now log checking and sent email if sth wrong
report_tripwire
