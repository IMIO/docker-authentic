#!/bin/bash
rm /var/run/{authentic2-multitenant/authentic2-multitenant,hobo/hobo,combo/combo,nginx,rsyslogd,supervisord}.{pid,sock}
/etc/hobo/fix-permissions.sh

HOSTNAME=$(hostname)
test -f /opt/publik/hooks/$HOSTNAME/run-hook.sh && /opt/publik/hooks/$HOSTNAME/run-hook.sh

service rsyslog start
service cron start

if [ x$1 != xfromgit ] || [ ! -d /opt/publik/combo ]
then
	service combo start
fi

if [ x$1 != xfromgit ] || [ ! -d /opt/publik/authentic ]
then
	service authentic2-multitenant update
	service authentic2-multitenant start
fi

service hobo start
service nginx start
service supervisor start
sudo -u hobo hobo-manage cook /etc/hobo/settings.d/recipe-wca.json
sudo -u hobo hobo-manage cook /etc/hobo/settings.d/recipe-wcu.json
test -e /etc/hobo/recipe*extra.json && sudo -u hobo hobo-manage cook /etc/hobo/recipe*extra.json
test -e /var/lib/authentic2-multitenant/tenants/agents*/settings.json || ln -s /etc/authentic2-multitenant/agents.json /var/lib/authentic2-multitenant/tenants/agents*/
test -e /var/lib/authentic2-multitenant/tenants/usagers*/settings.json || ln -s /etc/authentic2-multitenant/usagers.json /var/lib/authentic2-multitenant/tenants/usagers*/

tail -f /var/log/syslog
