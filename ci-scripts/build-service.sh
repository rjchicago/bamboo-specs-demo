#!/bin/sh
set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT
cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

export VERSION=${bamboo_ci_variables_VERSION:-test}

DOCKER_REGISTRY_URL=${bamboo_docker_registry_url:-}
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
docker-compose build
# test...

# PUSH TO DOCKER REGISTRY
if [[ ! -z $DOCKER_REGISTRY_PASSWORD ]] ; then
  export DOCKER_CONFIG="${bamboo_build_working_directory:-$(pwd)}/.docker"
  echo "$DOCKER_REGISTRY_PASSWORD" | docker login -u $DOCKER_REGISTRY_USER --password-stdin $DOCKER_REGISTRY_URL
  docker-compose push
  docker logout $DOCKER_REGISTRY_URL
fi
