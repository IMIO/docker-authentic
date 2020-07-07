pull:
		docker-compose pull

run:
		docker-composel up

up: run

build:
		docker-compose build --pull

build-no-cache:
		docker-compose build --no-cache --pull

cleanall:
		sudo rm -fr data/*/*/
		docker-compose down

add-user:
	docker-compose exec localauthentic bash -c 'authentic2-multitenant-manage tenant_command runscript /opt/publik/scripts/create-user.py -d local-auth.example.net'


create-plone4-site:
	docker-compose run --rm -v docker-authentic_plone4-data:/data plone4 buildout install plonesite
