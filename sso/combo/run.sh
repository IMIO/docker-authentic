#!/usr/bin/env bash
set -x
printenv >> /etc/environment # set env variables for cron jobs
rm /var/run/{combo/combo,rsyslogd}.{pid,sock}

#python3 /var/lib/authentic2/locale/fr/LC_MESSAGES/mail-translation.py

service rsyslog start
service cron start

if [ ! -d /opt/publik/combo ]
then
	service combo start
fi

tail -f /var/log/syslog
