# -*- coding: utf-8 -*-
from django.contrib.auth import get_user_model
from django_rbac.utils import get_ou_model
from hobo.agent.authentic2.provisionning import provisionning


def set_ou_to_authentic_admin_user():
    User = get_user_model()
    OU = get_ou_model()
    organisation_unit = OU.objects.get(default=True)
    with provisionning:
        # Set default user with default organisation unit.
        user_admin = User.objects.get(username="admin")
        if not user_admin.ou:
            user_admin.ou = organisation_unit
            user_admin.save()


set_ou_to_authentic_admin_user()
