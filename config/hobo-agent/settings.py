# AMQP message broker
# http://celery.readthedocs.org/en/latest/configuration.html#broker-url
# transport://userid:password@hostname:port/virtual_host
BROKER_URL = "amqp://guest:guest@rabbitmq:5672/"

# It's possible to limit agents to particular applications, or particular
# hostnames, using the AGENT_HOST_PATTERNS configuration variable.
#
# The format is a dictionary with applications as keys and a list of hostnames as
# value. The hostnames can be prefixed by an exclamation mark to exclude them.
#
AGENT_HOST_PATTERNS = {
    "authentic": ["agents.wc.localhost", "usagers.wc.localhost"],
    "combo": [
        "combo-agents.wc.localhost",
        "backoffice-agents.wc.localhost",
        "combo-usagers.wc.localhost",
        "backoffice-usagers.wc.localhost",
    ],
}

CACHES = {
    "default": {
        "BACKEND": "hobo.multitenant.cache.TenantCache",
        "REAL_BACKEND": "django.core.cache.backends.memcached.MemcachedCache",
        "LOCATION": "172.17.0.1:11211",
    }
}

AUTHENTIC_MANAGE_COMMAND = (
    "sudo -u authentic-multitenant /usr/bin/authentic2-multitenant-manage"
)
COMBO_MANAGE_COMMAND = "sudo -u combo /usr/bin/combo-manage"
HOBO_MANAGE_COMMAND = "sudo -u hobo /usr/bin/hobo-manage"
