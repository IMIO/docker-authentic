#!/usr/bin/make -f

run-test:
	docker compose -f docker-compose.yml -f docker-compose.test.yml up -d

up:
	docker compose up

build:
	docker compose build --pull authentic

build-no-cache:
	docker compose build --no-cache --pull

cleanall:
	docker compose -f docker-compose.yml -f docker-compose.test.yml down --volumes --remove-orphans
	sudo rm -rf data/hobo data/authentic2-multitenant data/combo

plone4-site:
	docker compose -f docker-compose.yml -f docker-compose.test.yml run --rm --no-deps plone4 buildout install plonesite

plone5-site:
	docker compose -f docker-compose.yml -f docker-compose.test.yml run --rm --no-deps plone5 buildout install plonesite

authentic-data:
	docker compose up database

authentic:
	docker compose run --rm  authentic ./build.sh

init-data: plone4-site plone5-site authentic

testing-env:
	docker compose up --no-start reverse-proxy # create network
	$(MAKE) init-data -j3
	$(MAKE) configure-wc

open-cypress:
	cypress open

run-cypress:
	docker compose -f docker-compose.yml -f docker-compose.test.yml up --exit-code-from cypress


add-oidc:
	docker compose run authentic bash -c 'authentic2-multitenant-manage tenant_command wc-base-import -d agents.traefik.me agents.json --no-dry-run NO_DRY_RUN'
	docker compose run authentic bash -c 'authentic2-multitenant-manage tenant_command wc-base-import -d usagers.traefik.me usagers.json --no-dry-run NO_DRY_RUN'

set-agents-admin-to-default-ou:
	docker compose run authentic bash -c 'authentic2-multitenant-manage tenant_command runscript /opt/scripts/set-ou-to-admin-user.py -d agents.traefik.me'

add-usagers-user:
	docker compose run authentic bash -c 'authentic2-multitenant-manage tenant_command runscript /opt/scripts/create-usagers-user.py -d usagers.traefik.me'

add-index-pages:
	docker compose run -u combo authentic bash -c 'combo-manage tenant_command import_site -d combo-agents.traefik.me /agents-index.json'
	docker compose run -u combo authentic bash -c 'combo-manage tenant_command import_site -d combo-usagers.traefik.me /usagers-index.json'


set-hobo-variable:
	docker compose run -u hobo authentic bash -c 'hobo-manage tenant_command runscript  /opt/scripts/set-hobo-variable.py -d hobo-agents.traefik.me'
	docker compose run -u hobo authentic bash -c 'hobo-manage tenant_command runscript  /opt/scripts/set-hobo-variable.py -d hobo-usagers.traefik.me'

configure-wc: set-agents-admin-to-default-ou add-usagers-user add-oidc add-index-pages set-hobo-variable


dev-cypress:
	docker compose up --no-start reverse-proxy
	$(MAKE) init-data
	$(MAKE) configure-wc
	docker compose -f docker-compose.yml -f docker-compose.test.yml up plone4 plone5 plone6 authentic

install-sassc:
	docker compose exec authentic apt update && apt install -y sassc

compile-sass:
	docker compose exec authentic sed -i 's/..\/..\/publik-base-theme/..\/..\/..\/publik-base/g' /usr/share/publik/themes/imio/static/wallonieconnect/*.scss
	docker compose exec authentic sassc /usr/share/publik/themes/imio/static/wallonieconnect/styles.scss /usr/share/publik/themes/imio/static/wallonieconnect/styles.css

.PHONY: certs
certs:
	mkdir certs
	wget traefik.me/cert.pem -O certs/cert.pem
	wget traefik.me/privkey.pem -O certs/privkey.pem
	wget traefik.me/fullchain.pem -O certs/fullchain.pem