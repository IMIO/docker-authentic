#!/usr/bin/env bash
set -x

/usr/bin/prometheus-uwsgi-exporter.py
mv /var/lib/prometheus/node-exporter/uwsgi.prom  /var/lib/prometheus/node-exporter/uwsgi-$INSTANCE_NAME.prom

/usr/bin/prometheus-system-exporter.py > /var/lib/prometheus/node-exporter/system-$INSTANCE_NAME.prom