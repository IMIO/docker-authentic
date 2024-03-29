"""
How to use me on container: 
# authentic2-multitenant-manage shell -d "$AGENTS_HOSTNAME" < /usr/bin/prometheus_user_exporter.py
"""
#! /usr/bin/python3
from datetime import timedelta
from django.utils import timezone
from django.contrib.auth import get_user_model
from django.contrib.sessions.models import Session
from prometheus_client import CollectorRegistry, Gauge
from prometheus_client.exposition import generate_latest

registry = CollectorRegistry()

total_users = Gauge(
    "waco_total_users",
    "Total users on Authentic",
    ["app"],
    registry=registry,
)
logged_users = Gauge(
    "waco_logged_users",
    "Logged users on Authentic",
    ["app"],
    registry=registry,
)
active_users = Gauge(
    "waco_active_users",
    "Users logged on last 30 days on Authentic",
    ["app"],
    registry=registry,
)
waco_type = "agents"
app_name = f"authentic-{waco_type}"
User = get_user_model()
users = User.objects.all()

# --- Total users
total_users.labels(app=app_name).set(len(users))

# --- Logged users
sessions = Session.objects.filter(expire_date__gte=timezone.now())
uid_logged = []
for session in sessions:
    data = session.get_decoded()
    uid_logged.append(data.get("_auth_user_id", None))

logged_users.labels(app=app_name).set(len(User.objects.filter(id__in=uid_logged)))

# --- Active users
actusers = []
for user in users:
    if user.last_login and user.last_login > timezone.now() - timedelta(days=30):
        actusers.append(user)

active_users.labels(app=app_name).set(len(actusers))


# write_to_textfile(
#     f"/var/lib/prometheus/node-exporter/waco_{waco_type}_users.prom", registry
# )
print(generate_latest(registry).decode())
