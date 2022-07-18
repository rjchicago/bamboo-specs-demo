#!/bin/sh

safe_string() {
   local str=$(echo $1 | awk '{print tolower($0)}')
   local re='(.*)[^a-z0-9.-]+(.*)'
   while [[ $str =~ $re ]]; do
      str=${BASH_REMATCH[1]}-${BASH_REMATCH[2]}
   done
   echo $str
}

get_version() {
   local branch=$1
   local build_number=$2
   local re='(master)|(main)|(trunk)'
   if [[ "$branch" =~ $re ]]; then
      echo "`date -u +%Y%m%d`-$build_number"
   else
      echo $(safe_string $branch)
   fi
}

# setting variables
BUILD_KEY=${bamboo_buildKey:-LOCAL}
BUILD_NUMBER=${bamboo_buildNumber:-0}
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
COMMIT_HASH=$(git rev-parse HEAD)
GENERATED_AT="`date -u +%Y-%m-%dT%H:%M:%SZ`"
VERSION=$(get_version $BRANCH $BUILD_NUMBER)

 # writing to file so Bamboo can read it
printf "VERSION=$VERSION
BRANCH=$BRANCH
BUILD_KEY=$BUILD_KEY
BUILD_NUMBER=$BUILD_NUMBER
GENERATED_AT=$GENERATED_AT
COMMIT_HASH=$COMMIT_HASH" > ci_variables
