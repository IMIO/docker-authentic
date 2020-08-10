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
		docker-compose -f docker-compose.yml -f docker-compose.test.yml down --volumes

add-user:
	docker-compose exec authentic bash -c 'authentic2-multitenant-manage tenant_command runscript /opt/publik/scripts/create-user.py -d agents.wc.localhost'

plone4-site:
	sleep 3  # wait zope
	docker-compose -f docker-compose.yml -f docker-compose.test.yml run --no-deps --rm plone4 buildout install plonesite

plone5-site:
	sleep 3 # wait zope
	docker-compose -f docker-compose.yml -f docker-compose.test.yml run --no-deps --rm plone5 buildout install plonesite

authentic-data:
	docker-compose up database

init-data-and-run: plone4-site plone5-site run

testing-env:
	docker-compose up --no-start reverse-proxy # create network
	$(MAKE) init-data-and-run -j3

open-cypress:
	npx cypress open

run-cypress:
	docker-compose -f docker-compose.yml -f docker-compose.test.yml up --exit-code-from cypress

localhost-env:
	docker-compose up -d

localhost-test-env:
	docker-compose -f docker-compose.yml -f docker-compose.test.yml -f docker-compose.test.local.yml up -d
	$(MAKE) plone4-site
	$(MAKE) plone5-site

dump-data:
	docker-compose up -d database
	docker-compose exec database pg_dumpall -U postgres --no-comments > data/docker-entrypoint-initdb.d/data.sql
	sed "s/CREATE ROLE postgres;/-- CREATE ROLE postgres;/" -i data/docker-entrypoint-initdb.d/data.sql 

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


add-oidc:
	docker-compose exec -T authentic bash -c 'authentic2-multitenant-manage tenant_command wc-base-import -d agents.wc.localhost agents.json --no-dry-run NO_DRY_RUN'
	docker-compose exec -T authentic bash -c 'authentic2-multitenant-manage tenant_command wc-base-import -d usagers.wc.localhost usagers.json --no-dry-run NO_DRY_RUN'

set-agents-admin-to-default-ou:
	docker-compose exec -T authentic bash -c 'authentic2-multitenant-manage tenant_command runscript /opt/publik/scripts/set-ou-to-admin-user.py -d agents.wc.localhost'

add-usagers-user:
	docker-compose exec -T authentic bash -c 'authentic2-multitenant-manage tenant_command runscript /opt/publik/scripts/create-usagers-user.py -d usagers.wc.localhost'

add-index-pages:
	docker-compose exec -T -u combo authentic bash -c 'combo-manage tenant_command import_site -d combo-agents.wc.localhost /agents-index.json'
	docker-compose exec -T -u combo authentic bash -c 'combo-manage tenant_command import_site -d combo-usagers.wc.localhost /usagers-index.json'

set-jenkins-data-ower:
	docker-compose run --rm authentic bash -c 'chown 110:65534 -R /var/lib/hobo/tenants /var/lib/combo/tenants /var/lib/authentic2-multitenant/tenants'
