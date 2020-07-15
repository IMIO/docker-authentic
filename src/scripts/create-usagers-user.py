# -*- coding: utf-8 -*-
from django.contrib.auth import get_user_model
from hobo.agent.authentic2.provisionning import provisionning


def create_authentic_user():
    email = "bsu+jdoe@imio.be"
    password = "jdoe"

    User = get_user_model()  # noqa
    with provisionning:
        # Create user with default organisation unit.
        User.objects.create_user(
            username="jdoe",
            first_name="John",
            last_name="Doe",
            email=email,
            password=password,
        )


create_authentic_user()
