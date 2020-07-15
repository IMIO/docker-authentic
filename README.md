This repo is a package of some [entr'ouvert](https://www.entrouvert.com) products.
It's a docker-compose based project to allow locally usage of e-guichet project.

### Requirements

docker-compose 1.6 or above

### Usage

- Compose and run the container image

  docker-compose up

- Create superuser

  docker-compose exec authentic authentic2-multitenant-manage createsuperuser --username admin --email bsu+admin@imio.be -d agents.wc.localhost

- Create admin WCA

  authentic2-multitenant-manage tenant_command runscript /opt/publik/scripts/create-user.py -d agents.wc.localhost

- Add agents/usagers services

  authentic2-multitenant-manage tenant_command wc-base-import -d "$AGENTS_HOSTNAME"  /agents.json --no-dry-run NO_DRY_RUN
  authentic2-multitenant-manage tenant_command wc-base-import -d "$USAGERS_HOSTNAME" /usagers.json --no-dry-run NO_DRY_RUN

- Sometimes, you need to init data multitimes (into container) with command :

  sudo -u hobo hobo-manage cook /etc/hobo/settings.d/recipe-wca.json
  sudo -u hobo hobo-manage cook /etc/hobo/settings.d/recipe-wcu.json

- Go to http://agents.wc.localhost with you favorite browser, an admin account is
  setup, username is "admin" and password is "password" (without the quotes).

### Development

You can clone modules into the src/ directory and they will automatically be
used in the container environment.

Supported modules are:

- combo
- imio-publik-themes (hence publik-base-theme)

Services will be run in django-runserver mode, and can be seen in a screen
session running in the container.

    docker exec -ti dockerauthentic_authentic_1 bash
    script -c "screen -r"
