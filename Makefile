pull:
		docker-compose pull

docker-compose.yml:
		ln -fs docker-compose.yml docker-compose.yml

run: docker-compose.yml
		docker-compose -f docker-compose.yml up

up: run

build: docker-compose.yml
		docker-compose build

build-no-cache: docker-compose.yml
		docker-compose build --no-cache

docker-image:
		cd sso && docker build -t sso:latest .

cleanall:
		sudo rm -fr data/*/*/
		docker-compose kill
		docker-compose rm -f
		docker-compose down

add-user:
	docker-compose exec localauthentic bash -c 'authentic2-multitenant-manage tenant_command runscript /opt/publik/scripts/create-user.py -d local-auth.example.net'
