#!/usr/bin/make -f

run:
	docker-compose up -d authentic

up: 
	docker-compose up

build:
		docker-compose build --pull authentic

build-no-cache:
		docker-compose build --no-cache --pull

cleanall:
		sudo rm -fr data/*/*/
		docker-compose down --volumes

add-user:
	docker-compose exec authentic bash -c 'authentic2-multitenant-manage tenant_command runscript /opt/publik/scripts/create-user.py -d agents.wc.localhost'


create-plone4-site:
	docker-compose run --rm -v docker-authentic_plone4-data:/data plone4 buildout install plonesite

wait-until-started:
	until [ -d data/combo/backoffice-usagers.wc.localhost ]; do echo "waiting..."; sleep 5; done
	echo "Tenants created" 
	sleep 5

add-oidc:
	docker-compose exec authentic bash -c 'authentic2-multitenant-manage tenant_command wc-base-import -d agents.wc.localhost agents.json --no-dry-run NO_DRY_RUN'
	docker-compose exec authentic bash -c 'authentic2-multitenant-manage tenant_command wc-base-import -d usagers.wc.localhost usagers.json --no-dry-run NO_DRY_RUN'

set-agents-admin-to-default-ou:
	docker-compose exec authentic bash -c 'authentic2-multitenant-manage tenant_command runscript /opt/publik/scripts/create-user.py -d agents.wc.localhost'

add-usagers-user:
	docker-compose exec authentic bash -c 'authentic2-multitenant-manage tenant_command runscript /opt/publik/scripts/create-usagers-user.py -d usagers.wc.localhost'

testing-env: run wait-until-started set-agents-admin-to-default-ou add-usagers-user add-oidc
	@echo "testing"
