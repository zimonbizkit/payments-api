all: help
##          _    __
##         | |  / /__  _____________
##         | | / / _ \/ ___/ ___/ _ \
##         | |/ /  __/ /  (__  )  __/
##         |________/_/  /_____\___/     _            __
##          /_  __/__  _____/ /_  ____  (_)________ _/ /
##           / / / _ \/ ___/ __ \/ __ \/ / ___/ __ `/ /
##          / / /  __/ /__/ / / / / / / / /__/ /_/ / /
##         /_/__///_/\___/_/ ///_/ /_/_/\___/\__,_/_/
##          /_  __/__  _____/ /_
##           / / / _ \/ ___/ __/
##          / / /  __(__  ) /_
##         /_/  \___/____/\__/
##
##
##
## @description	Makefile to build ,start, and troubleshooting of Eduard Simon's technical test to Verse
##
##
##
## Available commands are:
##
## ------------------------------------------------------------------------------------------------------
##
##
UID:=$(shell id -u)
GID:=$(shell id -g)
ROOT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

HOST_IP:= $(shell /sbin/ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | tail -1)
##	help:		Help of the project
. PHONY : help
help : Makefile
	@sed -n 's/^##//p' $<


##	up:		Brings the environment on
.PHONY : up
up:
	export HOST_IP=$(HOST_IP); \
	docker-compose -f docker-compose.yml up -d

##	down:		Turns down the environment
.PHONY : down
down:
	docker-compose down

##	shell:		Open a shell to the main project environment
.PHONY: shell
shell:
	docker-compose exec php sh

##	setup:		Sets up the project for the first time
.PHONY: setup
setup:
	export HOST_IP=$(HOST_IP); \
	docker-compose exec php sed -i s/yourip/$(HOST_IP)/g .env; \
	docker-compose exec php composer install
	docker-compose exec goe2e sh e2e_tests/buildAndIncludeCommand.sh

##	test:		Run the unit tests
.PHONY: test
test:
	docker-compose exec php ./vendor/phpunit/phpunit/phpunit --testdox


##	go-env:		Check the environment variables generated in the go environment
.PHONY: go-env
go-env:
	docker-compose exec goe2e go env
	docker-compose exec goe2e go run e2e_tests/test.go

##	e2e:		Fires the e2e tests concurrently
.PHONY: e2e
e2e:
	docker-compose exec goe2e echo "$(HOST_IP)" > hostip
	docker-compose exec --env HOSTIP=$(HOST_IP) goe2e ./godog e2e_tests/features/
##
##
## ------------------------------------------------------------------------------------------------------
