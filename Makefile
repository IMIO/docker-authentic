#!/usr/bin/make -f

run:
	docker-compose -f docker-compose.yml -f docker-compose.test.yml up -d

up:
	docker-compose up

build:
		docker-compose build --pull authentic

build-no-cache:
		docker-compose build --no-cache --pull

cleanall:
		sudo rm -fr data/*/*/
		docker-compose -f docker-compose.yml -f docker-compose.test.yml down --volumes

add-user:
	docker-compose exec authentic bash -c 'authentic2-multitenant-manage tenant_command runscript /opt/publik/scripts/create-user.py -d agents.wc.localhost'

plone4-site:
	docker-compose -f docker-compose.yml -f docker-compose.test.yml run --rm -v docker-authentic_plone4-data:/data plone4 buildout install plonesite

wait-until-started:
	until [ -d data/combo/backoffice-usagers.wc.localhost ]; do echo "waiting..."; sleep 10; done
	echo "Tenants created"
	sleep 3

add-oidc:
	docker-compose exec authentic bash -c 'authentic2-multitenant-manage tenant_command wc-base-import -d agents.wc.localhost agents.json --no-dry-run NO_DRY_RUN'
	docker-compose exec authentic bash -c 'authentic2-multitenant-manage tenant_command wc-base-import -d usagers.wc.localhost usagers.json --no-dry-run NO_DRY_RUN'

set-agents-admin-to-default-ou:
	docker-compose exec authentic bash -c 'authentic2-multitenant-manage tenant_command runscript /opt/publik/scripts/set-ou-to-admin-user.py -d agents.wc.localhost'

add-usagers-user:
	docker-compose exec authentic bash -c 'authentic2-multitenant-manage tenant_command runscript /opt/publik/scripts/create-usagers-user.py -d usagers.wc.localhost'

add-index-pages:
	docker-compose exec -u combo authentic bash -c 'combo-manage tenant_command import_site -d combo-agents.wc.localhost /index.json'
	docker-compose exec -u combo authentic bash -c 'combo-manage tenant_command import_site -d combo-usagers.wc.localhost /index.json'

testing-env: plone4-site run wait-until-started set-agents-admin-to-default-ou add-usagers-user add-oidc add-index-pages
	@echo "testing"

open-cypress:
	npx cypress open

run-cypress:
	docker-compose -f docker-compose.yml -f docker-compose.test.yml up --exit-code-from cypress
