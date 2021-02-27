SHELL := /bin/bash

start: export APP_ENV=dev
	symfony server:start -dn
	docker-compose up -d
	symfony run -dn --watch=config,src,templates,vendor symfony console messenger:consume async

tests: export APP_ENV=test
tests:
	symfony console doctrine:database:drop --force || true
	symfony console doctrine:database:create
	symfony console doctrine:migrations:migrate -n
	symfony console doctrine:fixtures:load -n
	symfony php bin/phpunit $@
.PHONY: tests start

