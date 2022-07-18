#!/bin/sh
set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT
cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

export VERSION=${bamboo_ci_variables_VERSION:-test}
export NODE_ENV=${bamboo_NODE_ENV:-test}
export REPLICAS=${bamboo_REPLICAS:-1}

# deploy
# ...
