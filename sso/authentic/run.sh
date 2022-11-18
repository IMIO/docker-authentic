#!/usr/bin/env bash
set -x
chown authentic-multitenant:authentic-multitenant -R /var/lib/authentic2-multitenant
printenv >> /etc/environment # set env variables for cron jobs
# rm /var/run/{authentic2-multitenant/authentic2-multitenant,rsyslogd,supervisord}.{pid,sock}

# service supervisor start
# service rsyslog start
# service cron start

# if [ ! -d /opt/publik/authentic ]
# then
# 	# service authentic2-multitenant update
# 	service authentic2-multitenant start
# fi

if [[ -n "${AGENTS_HOSTNAME}" ]]; then
	test -e "/var/lib/authentic2-multitenant/tenants/$AGENTS_HOSTNAME/settings.json" || ln -s /etc/authentic2-multitenant/agents.json "/var/lib/authentic2-multitenant/tenants/$AGENTS_HOSTNAME/settings.json"
fi
if [[ -n "${USAGERS_HOSTNAME}" ]]; then
	test -e "/var/lib/authentic2-multitenant/tenants/$USAGERS_HOSTNAME/settings.json" || ln -s /etc/authentic2-multitenant/usagers.json "/var/lib/authentic2-multitenant/tenants/$USAGERS_HOSTNAME/settings.json"
fi

# tail -f /var/log/syslog
/usr/bin/uwsgi --pidfile=/run/authentic2-multitenant/authentic2-multitenant.pid \
--uid authentic2 --gid authentic2 \
--ini /etc/authentic2-multitenant/authentic2-multitenant-uwsgi.ini \
--spooler /var/lib/authentic2-multitenant/spooler/ \
--daemonize /var/log/uwsgi.authentic2-multitenant.log \
--http-socket 0.0.0.0:8080