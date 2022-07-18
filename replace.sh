#!/bin/sh

# load environment variables
set -o allexport; source .env; set +o allexport

function sed_escape() {
  echo $(echo $1 | sed -E 's/\./\\\./g')
}

function replace_var() {
  local VAR=$1
  local VAL=$(eval "echo \$$VAR")
  local VAL_ESCAPED=$(sed_escape "$VAL")
  echo "replacing {{$VAR}} --> $VAL"
  find . -type f -name "*.yml" -exec sed -i '' -e "s#{{$VAR}}#$VAL_ESCAPED#g" {} +
  find . -type f -name "*.sh" -exec sed -i '' -e "s#{{$VAR}}#$VAL_ESCAPED#g" {} +
}

# replace vars
replace_var REPLACE_PROJECT_KEY
replace_var REPLACE_BUILD_KEY
replace_var REPLACE_BUILD_NAME
replace_var REPLACE_DEPLOY_NAME
replace_var REPLACE_COMPOSE_FILE
