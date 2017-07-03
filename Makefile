branch=use-modules-from-git-clones

pull:
		docker-compose pull

clean:
		docker-compose kill
		docker-compose rm
		sudo rm -fr data/*/*/

run:
		docker-compose -f docker-compose-$(branch).yml up

build:
		docker-compose -f docker-compose-$(branch).yml build

build-no-cache:
		docker-compose -f docker-compose-$(branch).yml build --no-cache

run-jessie:
		make run branch=jessie
build-jessie:
		make build branch=jessie
build-no-cache-jessie:
		make build-no-cache branch=jessie

docker-prod-image:
		cd authentic && docker build -f Dockerfile-jessie -t authentic:latest .

cleanall:
		sudo rm -rf data/combo/* data/authentic2/* data/hobo/*
		docker-compose stop
		docker-compose rm -f
		docker rmi authentic-jessie
		docker rmi authentic-use-modules-from-git-clones
