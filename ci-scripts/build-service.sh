#!/bin/sh
set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT
cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

export COMPOSE_INTERACTIVE_NO_CLI=1
export VERSION=${bamboo_ci_variables_VERSION:-test}

COMPOSE_FILE=${bamboo_compose_file:-docker-compose.ci.yml}
DOCKER_REGISTRY_URL=${bamboo_docker_registry_url:-dtr.cnvr.net}
DOCKER_REGISTRY_USER=${bamboo_docker_registry_user:-}
DOCKER_REGISTRY_PASSWORD=${bamboo_docker_registry_password:-}

# hook for local testing
if [[ -z $DOCKER_REGISTRY_USER ]] ; then
  echo "Docker Registry User (or hit ENTER to skip Docker Registry push):" 
  read DOCKER_REGISTRY_USER
fi
if [[ ! -z $DOCKER_REGISTRY_USER ]] && [[ -z $DOCKER_REGISTRY_PASSWORD ]] ; then
  echo "Docker Registry Password for $DOCKER_REGISTRY_USER:" 
  read -s DOCKER_REGISTRY_PASSWORD
fi

# build
docker-compose -f $COMPOSE_FILE build {{REPLACE_SERVICE_NAME}}
# TODO: docker-compose up, test, etc...
# mkdir -p ./test-reports # <-- create mapped volume directories
# docker-compose -f $COMPOSE_FILE up -d --build
# docker-compose -f $COMPOSE_FILE exec {{REPLACE_SERVICE_NAME}} npm test

# PUSH TO DOCKER REGISTRY
if [[ ! -z $DOCKER_REGISTRY_PASSWORD ]] ; then
  export DOCKER_CONFIG="${bamboo_build_working_directory:-$(pwd)}/.docker"
  echo "$DOCKER_REGISTRY_PASSWORD" | docker login -u $DOCKER_REGISTRY_USER --password-stdin $DOCKER_REGISTRY_URL
  docker-compose -f $COMPOSE_FILE push {{REPLACE_SERVICE_NAME}}
  docker logout $DOCKER_REGISTRY_URL
fi
