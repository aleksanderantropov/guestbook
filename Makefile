SHELL := /bin/bash

start: export APP_ENV=dev
start:
	symfony server:start -d
	docker-compose up -d
	symfony run -d --watch=config,src,templates,vendor symfony console messenger:consume async
	symfony run -d yarn encore dev --watch

stop: export APP_ENV=dev
stop:
	symfony server:stop
	docker-compose stop
	
tests: export APP_ENV=test
tests:
	symfony console doctrine:database:drop --force || true
	symfony console doctrine:database:create
	symfony console doctrine:migrations:migrate -n
	symfony console doctrine:fixtures:load -n
	symfony php bin/phpunit $@
.PHONY: tests start stop

