#!/usr/bin/env bash
set -x
while true;
do
    sleep 2m
    authentic2-multitenant-manage shell -d "$AGENTS_HOSTNAME" < /usr/bin/prometheus_user_exporter.py > /var/lib/prometheus/node-exporter/authentic_users.prom
done;