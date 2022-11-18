#!/usr/bin/env bash
set -x
printenv >> /etc/environment # set env variables for cron jobs
# rm /var/run/{authentic2-multitenant/authentic2-multitenant,hobo/hobo,combo/combo,nginx,rsyslogd,supervisord}.{pid,sock}
/etc/hobo/fix-permissions.sh

service hobo start
service rsyslog start
service cron start

sudo -u hobo hobo-manage cook /etc/hobo/settings.d/recipe-wca.json --timeout=600
sudo -u hobo hobo-manage cook /etc/hobo/settings.d/recipe-wcu.json --timeout=600
test -e /etc/hobo/recipe*extra.json && sudo -u hobo hobo-manage cook /etc/hobo/recipe*extra.json

/etc/hobo/fix-permissions.sh
tail -f /var/log/syslog
