# -*- coding: utf-8 -*-
from django.contrib.auth import get_user_model
from authentic2.a2_rbac.utils import get_default_ou
from hobo.agent.authentic2.provisionning import provisionning
from authentic2.apps.authenticators.models import LoginPasswordAuthenticator


def set_ou_to_authentic_admin_user():
    User = get_user_model()
    organisation_unit = get_default_ou()
    with provisionning:
        # Set default user with default organisation unit.
        user_admin = User.objects.get(username="admin")
        if not user_admin.ou:
            user_admin.ou = organisation_unit
            user_admin.save()
    LoginPasswordAuthenticator.objects.update(include_ou_selector=True)


set_ou_to_authentic_admin_user()
