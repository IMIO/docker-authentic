# -*- coding: utf-8 -*-
# Configuration for authentic.
# You can override Authentic default settings here

# Authentic is a Django application: for the full list of settings and their
# values, see https://docs.djangoproject.com/en/1.7/ref/settings/
# For more information on settings see
# https://docs.djangoproject.com/en/1.7/topics/settings/

# WARNING! Quick-start development settings unsuitable for production!
# See https://docs.djangoproject.com/en/1.7/howto/deployment/checklist/

# This file is sourced by "execfile" from /usr/lib/authentic/debian_config.py

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True
# TEMPLATES[0]["OPTIONS"]["debug"] = True


ADMINS = (("Admins IMIO", "adminwc@imio.be"),)

# ALLOWED_HOSTS must be correct in production!
# See https://docs.djangoproject.com/en/dev/ref/settings/#allowed-hosts
ALLOWED_HOSTS = [
    "agents.wc.localhost",
    "usagers.wc.localhost",
]


# Databases
# Default: a local database named "authentic"
# https://docs.djangoproject.com/en/1.7/ref/settings/#databases
# Warning: don't change ENGINE
DATABASES["default"]["NAME"] = "authentic2"
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

# Sentry / Raven configuration
# RAVEN_CONFIG = {
#    'dsn': '',
# }

# Email configuration
EMAIL_SUBJECT_PREFIX = "[authentic local_authentic2]"
SERVER_EMAIL = "authentic2@wc.localhost"
DEFAULT_FROM_EMAIL = "authentic2@wc.localhost"

# SMTP configuration
EMAIL_HOST = "localhost"
# EMAIL_HOST_USER = ''
# EMAIL_HOST_PASSWORD = ''
# EMAIL_PORT = 25

# HTTPS Security
CSRF_COOKIE_SECURE = False
SESSION_COOKIE_SECURE = False

# Idp
# SAML 2.0 IDP
A2_IDP_SAML2_ENABLE = True
# CAS 1.0 / 2.0 IDP
# A2_IDP_CAS_ENABLE = False
# OpenID 1.0 / 2.0 IDP
# A2_IDP_OPENID_ENABLE = False
MELLON_ADAPTER = ("authentic2_auth_fedict.adapters.AuthenticAdapter",)

# Authentifications
# A2_AUTH_PASSWORD_ENABLE = True
# A2_SSLAUTH_ENABLE = False

HOBO_ROLE_EXPORT = True
BROKER_URL = "amqp://guest:guest@rabbitmq:5672/"

LOCALE_PATHS = ("/var/lib/authentic2/locale",) + LOCALE_PATHS

A2_IDP_OIDC_SCOPES = ["openid", "email", "profile", "roles"]
