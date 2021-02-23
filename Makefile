#!/usr/bin/make -f

test-run:
	docker-compose -f docker-compose.yml -f docker-compose.test.yml up -d

up:
	docker-compose up

build:
	docker-compose build --pull authentic

build-no-cache:
	docker-compose build --no-cache --pull

cleanall:
	docker-compose -f docker-compose.yml -f docker-compose.test.yml down --volumes --remove-orphans
	sudo rm -rf data/hobo data/authentic2-multitenant data/combo

add-user:
	docker-compose exec authentic bash -c 'authentic2-multitenant-manage tenant_command runscript /opt/publik/scripts/create-user.py -d agents.wc.localhost'

plone4-site:
	docker-compose -f docker-compose.yml -f docker-compose.test.yml run --rm --no-deps plone4 buildout install plonesite

plone5-site:
	docker-compose -f docker-compose.yml -f docker-compose.test.yml run --rm --no-deps plone5 buildout install plonesite

authentic-data:
	docker-compose up database

authentic:
	docker-compose run --rm  authentic ./build.sh

init-data: plone4-site plone5-site authentic

testing-env:
	docker-compose up --no-start reverse-proxy # create network
	$(MAKE) init-data -j3
	$(MAKE) configure-wc
	# $(MAKE) test-run

open-cypress:
	npx cypress open

run-cypress:
	docker-compose -f docker-compose.yml -f docker-compose.test.yml up --exit-code-from cypress

wait-until-started:
	until [ -d data/combo/backoffice-usagers.wc.localhost ]; do echo "waiting for creation of tenants..."; sleep 10; done
	echo "Tenants created"
	sleep 1
	while [ "`docker inspect -f {{.State.Health.Status}} $$(docker-compose ps -q database)`" != "healthy" ]; do echo "waiting for postgres..."; sleep 3; done
	echo "Postgres ready"
	sleep 1
	while [ "`docker inspect -f {{.State.Health.Status}} $$(docker-compose -f docker-compose.yml -f docker-compose.test.yml ps -q plone4)`" != "healthy" ]; do echo "waiting for plone4..."; sleep 3; done
	echo "Plone 4 ready"
	while [ "`docker inspect -f {{.State.Health.Status}} $$(docker-compose -f docker-compose.yml -f docker-compose.test.yml ps -q plone5)`" != "healthy" ]; do echo "waiting for plone5..."; sleep 3; done
	echo "Plone 5 ready"
	# while [ "`docker inspect -f {{.State.Health.Status}} $$(docker-compose ps -q authentic)`" != "healthy" ]; do echo "waiting for authenitc..."; sleep 3; done
	echo "Authentic ready"


add-oidc:
	docker-compose run authentic bash -c 'authentic2-multitenant-manage tenant_command wc-base-import -d agents.wc.localhost agents.json --no-dry-run NO_DRY_RUN'
	docker-compose run authentic bash -c 'authentic2-multitenant-manage tenant_command wc-base-import -d usagers.wc.localhost usagers.json --no-dry-run NO_DRY_RUN'

set-agents-admin-to-default-ou:
	docker-compose run authentic bash -c 'authentic2-multitenant-manage tenant_command runscript /opt/scripts/set-ou-to-admin-user.py -d agents.wc.localhost'

add-usagers-user:
	docker-compose run authentic bash -c 'authentic2-multitenant-manage tenant_command runscript /opt/scripts/create-usagers-user.py -d usagers.wc.localhost'

add-index-pages:
	docker-compose run -u combo authentic bash -c 'combo-manage tenant_command import_site -d combo-agents.wc.localhost /agents-index.json'
	docker-compose run -u combo authentic bash -c 'combo-manage tenant_command import_site -d combo-usagers.wc.localhost /usagers-index.json'


set-hobo-variable:
	docker-compose run -u hobo authentic bash -c 'hobo-manage tenant_command runscript  /opt/scripts/set-hobo-variable.py -d hobo-agents.wc.localhost'
	docker-compose run -u hobo authentic bash -c 'hobo-manage tenant_command runscript  /opt/scripts/set-hobo-variable.py -d hobo-usagers.wc.localhost'

configure-wc: set-agents-admin-to-default-ou add-usagers-user add-oidc add-index-pages set-hobo-variable

