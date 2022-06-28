#! /usr/bin/python3

import collections
import glob
import json
import os
import socket
import statistics

from django.contrib.auth import get_user_model
from django.contrib.sessions.models import Session
from django.utils import timezone
from prometheus_client import CollectorRegistry, Gauge, write_to_textfile

registry = CollectorRegistry()

uwsgi_workers_rss_avg = Gauge(
    "uwsgi_workers_rss_avg",
    "Average RSS of uwsgi workers",
    ["app", "compose_service"],
    registry=registry,
)
uwsgi_workers_rss_med = Gauge(
    "uwsgi_workers_rss_med",
    "Median RSS of uwsgi workers",
    ["app", "compose_service"],
    registry=registry,
)
uwsgi_workers_rss_max = Gauge(
    "uwsgi_workers_rss_max",
    "Maximum RSS of uwsgi workers",
    ["app", "compose_service"],
    registry=registry,
)
uwsgi_workers_rss_total = Gauge(
    "uwsgi_workers_rss_total",
    "Total RSS of uwsgi workers",
    ["app", "compose_service"],
    registry=registry,
)
uwsgi_workers_vsz_avg = Gauge(
    "uwsgi_workers_vsz_avg",
    "Average VSZ of uwsgi workers",
    ["app", "compose_service"],
    registry=registry,
)
uwsgi_workers_vsz_med = Gauge(
    "uwsgi_workers_vsz_med",
    "Median VSZ of uwsgi workers",
    ["app", "compose_service"],
    registry=registry,
)
uwsgi_workers_vsz_max = Gauge(
    "uwsgi_workers_vsz_max",
    "Maximum VSZ of uwsgi workers",
    ["app", "compose_service"],
    registry=registry,
)
uwsgi_workers_vsz_total = Gauge(
    "uwsgi_workers_vsz_total",
    "Total VSZ of uwsgi workers",
    ["app", "compose_service"],
    registry=registry,
)
uwsgi_workers_status = Gauge(
    "uwsgi_workers_status",
    "uwsgi workers status",
    ["app", "status", "compose_service"],
    registry=registry,
)
total_users = Gauge(
    "total_users",
    "Total users on Authentic",
    ["app", "compose_service"],
    registry=registry,
)
logged_users = Gauge(
    "logged_users",
    "Logged users on Authentic",
    ["app", "compose_service"],
    registry=registry,
)
app_name = None

for stats_sock in glob.glob("/run/*/stats.sock"):
    app_name = stats_sock.split("/")[2]
    app_name = app_name.replace("authentic2-multitenant", "authentic")
    # if app_name == "authentic":
    #     # do not collect authentic data as it triggers some uwsgi bug
    #     # https://dev.entrouvert.org/issues/54624
    #     continue
    stats_json = ""
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as s:
        s.connect(stats_sock)
        while True:
            data = s.recv(4096)
            if not data:
                break
            stats_json += data.decode("utf8", "ignore")
    stats_data = json.loads(stats_json)

    listen_queue = stats_data["listen_queue"]
    workers_rss = []
    workers_vsz = []
    workers_status = collections.defaultdict(int)
    workers_status["idle"] = 0
    workers_status["busy"] = 0
    for worker in stats_data["workers"]:
        if worker["status"] == "cheap":
            continue
        workers_status[worker["status"]] += 1
        workers_rss.append(worker["rss"])
        workers_vsz.append(worker["vsz"])
    compose_service = os.getenv("INSTANCE_NAME")
    uwsgi_workers_rss_total.labels(app=app_name, compose_service=compose_service).set(
        sum(workers_rss)
    )
    uwsgi_workers_rss_max.labels(app=app_name, compose_service=compose_service).set(
        max(workers_rss)
    )
    uwsgi_workers_rss_avg.labels(app=app_name, compose_service=compose_service).set(
        statistics.mean(workers_rss)
    )
    uwsgi_workers_rss_med.labels(app=app_name, compose_service=compose_service).set(
        statistics.median(workers_rss)
    )
    uwsgi_workers_vsz_total.labels(app=app_name, compose_service=compose_service).set(
        sum(workers_vsz)
    )
    uwsgi_workers_vsz_max.labels(app=app_name, compose_service=compose_service).set(
        max(workers_vsz)
    )
    uwsgi_workers_vsz_avg.labels(app=app_name, compose_service=compose_service).set(
        statistics.mean(workers_vsz)
    )
    uwsgi_workers_vsz_med.labels(app=app_name, compose_service=compose_service).set(
        statistics.median(workers_vsz)
    )
    for k in workers_status:
        uwsgi_workers_status.labels(
            app=app_name, status=k, compose_service=compose_service
        ).set(workers_status[k])

User = get_user_model()
users = User.objects.all()
total_users.labels(app=app_name, compose_service=compose_service).set(len(users))


def get_all_logged_in_users():
    # Query all non-expired sessions
    # use timezone.now() instead of datetime.now() in latest versions of Django
    sessions = Session.objects.filter(expire_date__gte=timezone.now())
    uid_list = []

    # Build a list of user ids from that query
    for session in sessions:
        data = session.get_decoded()
        uid_list.append(data.get("_auth_user_id", None))

    # Query all logged in users based on id list
    User = get_user_model()
    return User.objects.filter(id__in=uid_list)


logged_users.labels(app=app_name, compose_service=compose_service).set(
    len(get_all_logged_in_users())
)

if app_name:
    write_to_textfile("/var/lib/prometheus/node-exporter/uwsgi.prom", registry)
else:
    # host for containers?
    content = ""
    for machine_stat in glob.glob(
        "/var/lib/machines/*/var/lib/prometheus/node-exporter/uwsgi.prom"
    ):
        with open(machine_stat) as fd:
            content += fd.read()
    if content:
        with open("/var/lib/prometheus/node-exporter/uwsgi.prom.tmp", "w") as fd:
            fd.write(content)
        os.rename(
            "/var/lib/prometheus/node-exporter/uwsgi.prom.tmp",
            "/var/lib/prometheus/node-exporter/uwsgi.prom",
        )
