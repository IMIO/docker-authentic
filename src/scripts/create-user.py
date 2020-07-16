# -*- coding: utf-8 -*-
from django.contrib.auth import get_user_model
from django_rbac.utils import get_role_model, get_ou_model
from hobo.agent.authentic2.provisionning import provisionning


def create_authentic_user():
    User = get_user_model()
    OU = get_ou_model()
    Role = get_role_model()
    organisation_unit = OU.objects.get(default=True)
    with provisionning:
        role_admin, created = Role.objects.get_or_create(
            name="Administrateur de tous les utilisateurs", ou=organisation_unit
        )

        with open("/tmp/tmp_uuid_agent_admin.txt", "w") as f:
            f.write(role_admin.uuid)

        # Set default user with default organisation unit.
        user_admin = User.objects.get(username="admin")
        if not user_admin.ou:
            user_admin.ou = organisation_unit
            user_admin.save()

        # Set role to user
        role_admin.members.add(user_admin)


create_authentic_user()
