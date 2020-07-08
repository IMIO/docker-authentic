# -*- coding: utf-8 -*-
# Configuration for hobo
# You can override Hobo default settings here

# Combo is a Django application: for the full list of settings and their
# values, see https://docs.djangoproject.com/en/1.7/ref/settings/
# For more information on settings see
# https://docs.djangoproject.com/en/1.7/topics/settings/

# WARNING! Quick-start development settings unsuitable for production!
# See https://docs.djangoproject.com/en/1.7/howto/deployment/checklist/

# This file is sourced by "execfile" from /usr/lib/combo/debian_config.py

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = False
TEMPLATE_DEBUG = False

ADMINS = (("Admin IMIO", "adminwc@imio.be"),)

# ALLOWED_HOSTS must be correct in production!
# See https://docs.djangoproject.com/en/dev/ref/settings/#allowed-hosts
ALLOWED_HOSTS = [
    "hobo-agents.wc.localhost",
    "hobo-usagers.wc.localhost",
]

# Databases
# Default: a local database named "hobo"
# https://docs.djangoproject.com/en/1.7/ref/settings/#databases
# Warning: don't change ENGINE
DATABASES["default"]["NAME"] = "hobo"
DATABASES["default"]["USER"] = "postgres"
DATABASES["default"]["PASSWORD"] = "password"
DATABASES["default"]["HOST"] = "database"
DATABASES["default"]["PORT"] = "5432"

CACHES = {
    "default": {
        "BACKEND": "hobo.multitenant.cache.TenantCache",
        "REAL_BACKEND": "django.core.cache.backends.memcached.MemcachedCache",
        "LOCATION": "memcached:11211",
    }
}

LANGUAGE_CODE = "fr-be"
TIME_ZONE = "Europe/Brussels"

# Email configuration
EMAIL_SUBJECT_PREFIX = "[hobo local]"
SERVER_EMAIL = "hobo@wc.localhost"
DEFAULT_FROM_EMAIL = "hobo@wc.localhost"

# SMTP configuration
EMAIL_HOST = "localhost"
# EMAIL_HOST_USER = ''
# EMAIL_HOST_PASSWORD = ''
# EMAIL_PORT = 25

# HTTPS Security
CSRF_COOKIE_SECURE = False
SESSION_COOKIE_SECURE = False
BROKER_URL = "amqp://guest:guest@rabbitmq:5672/"
