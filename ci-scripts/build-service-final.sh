#!/bin/sh

COMPOSE_FILE=${bamboo_compose_file:-docker-compose.yml}
docker-compose -f $COMPOSE_FILE down --rmi local
