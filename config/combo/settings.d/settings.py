# -*- coding: utf-8 -*-
# Configuration for combo.
# You can override Combo default settings here

# Combo is a Django application: for the full list of settings and their
# values, see https://docs.djangoproject.com/en/1.7/ref/settings/
# For more information on settings see
# https://docs.djangoproject.com/en/1.7/topics/settings/

# WARNING! Quick-start development settings unsuitable for production!
# See https://docs.djangoproject.com/en/1.7/howto/deployment/checklist/

# This file is sourced by "execfile" from /usr/lib/combo/debian_config.py

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True
# TEMPLATES[0]["OPTIONS"]["debug"] = True


ADMINS = (("Admins IMIO", "adminwaco@imio.be"),)

# ALLOWED_HOSTS must be correct in production!
# See https://docs.djangoproject.com/en/dev/ref/settings/#allowed-hosts
ALLOWED_HOSTS = [
    "combo-agents.dev.publik.love",
    "backoffice-agents.dev.publik.love",
    "combo-usagers.dev.publik.love",
    "backoffice-usagers.dev.publik.love",
]

# Databases
# Default: a local database named "combo"
# https://docs.djangoproject.com/en/1.7/ref/settings/#databases
# Warning: don't change ENGINE
DATABASES["default"]["NAME"] = "combo"
DATABASES["default"]["USER"] = "postgres"
DATABASES["default"]["PASSWORD"] = "password"
DATABASES["default"]["HOST"] = "database"
DATABASES["default"]["PORT"] = "5432"

CACHES = {
    "default": {
        "BACKEND": "hobo.multitenant.cache.TenantCache",
        "REAL_BACKEND": "django.core.cache.backends.memcached.PyMemcacheCache",
        "LOCATION": "memcached:11211",
    }
}

LANGUAGE_CODE = "fr-be"
TIME_ZONE = "Europe/Brussels"

# Email configuration
EMAIL_SUBJECT_PREFIX = "[combo local]"
SERVER_EMAIL = "combo@localhost"
DEFAULT_FROM_EMAIL = "combo@localhost"

# SMTP configuration
EMAIL_HOST = "localhost"
# EMAIL_HOST_USER = ''
# EMAIL_HOST_PASSWORD = ''
# EMAIL_PORT = 25

# HTTPS Security
CSRF_COOKIE_SECURE = False
SESSION_COOKIE_SECURE = False
