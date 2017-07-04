# -*- coding: utf-8 -*-
from authentic2.compat import get_user_model
from django_rbac.utils import get_role_model, get_ou_model
from hobo.agent.authentic2.provisionning import provisionning

import argparse
import hashlib


def create_authentic_user():
    parser = argparse.ArgumentParser()
    parser.add_argument('-u', '--username', dest='username',
                        type=str, default='bsuttor',
                        help='User name'
                        )
    parser.add_argument('-e', '--email', dest='email',
                        type=str, default='bsu@imio.be',
                        help='User e-mail'
                        )
    parser.add_argument('-p', '--password', dest='password',
                        type=str, default='password',
                        help='User password'
                        )
    args = parser.parse_args()

    username = args.username
    email = args.email
    password = args.password

    User = get_user_model()
    OU = get_ou_model()
    Role = get_role_model()
    organisation_unit = OU.objects.get(default=True)
    with provisionning:
        # create default role in ts2.
        role_admin = Role(
            name='Administrateur des utilisateurs',
            ou=organisation_unit)
        role_admin.save()

        with open('/tmp/tmp_uuid_agent_admin.txt', 'w') as f:
            f.write(role_admin.uuid)

        # Create default user with default organisation unit.
        user_admin = User(username=username, email=email, ou=organisation_unit)
        user_admin.set_password(create_password(password))
        user_admin.save()

        # Set role to user
        role_admin.members.add(user_admin)


def create_password(password):
    m = hashlib.md5(password)
    return m.hexdigest()[10]


create_authentic_user()
