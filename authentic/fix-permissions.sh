#!/bin/sh
set +ex
chown authentic-multitenant:authentic-multitenant /var/lib/authentic2-multitenant/tenants -R
chown hobo:hobo /var/lib/hobo/tenants -R
chown combo:combo /var/lib/combo/tenants -R
