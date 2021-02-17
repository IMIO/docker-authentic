#!/usr/bin/env bash
set -x
rm /var/run/{authentic2-multitenant/authentic2-multitenant,hobo/hobo,combo/combo,nginx,rsyslogd,supervisord}.{pid,sock}
/etc/hobo/fix-permissions.sh

#python3 /var/lib/authentic2/locale/fr/LC_MESSAGES/mail-translation.py

HOSTNAME=$(hostname)
test -f "/opt/publik/hooks/$HOSTNAME/run-hook.sh" && "/opt/publik/hooks/$HOSTNAME/run-hook.sh"


service hobo start
service supervisor start

service rsyslog start
service cron start

if [ ! -d /opt/publik/combo ]
then
	service combo start
fi

if [ ! -d /opt/publik/authentic ]
then
	# service authentic2-multitenant update
	service authentic2-multitenant start
fi

service nginx start
sudo -u hobo hobo-manage cook /etc/hobo/settings.d/recipe-wca.json --timeout=600
sudo -u hobo hobo-manage cook /etc/hobo/settings.d/recipe-wcu.json --timeout=600
test -e /etc/hobo/recipe*extra.json && sudo -u hobo hobo-manage cook /etc/hobo/recipe*extra.json
if [[ ! -z "${AGENTS_HOSTNAME}" ]]; then
	test -e "/var/lib/authentic2-multitenant/tenants/$AGENTS_HOSTNAME/settings.json" || ln -s /etc/authentic2-multitenant/agents.json "/var/lib/authentic2-multitenant/tenants/$AGENTS_HOSTNAME/settings.json"
fi
if [[ ! -z "${USAGERS_HOSTNAME}" ]]; then
	test -e "/var/lib/authentic2-multitenant/tenants/$USAGERS_HOSTNAME/settings.json" || ln -s /etc/authentic2-multitenant/usagers.json "/var/lib/authentic2-multitenant/tenants/$USAGERS_HOSTNAME/settings.json"
fi
/etc/hobo/fix-permissions.sh
tail -f /var/log/syslog
