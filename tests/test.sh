#!/usr/bin/env bash

# Build and test all the containers.

set -e
[ "${DEBUG}" == 'true' ] && set -x

function build_container {
  VER="$1"
  pushd ${VER} 1> /dev/null
  echo ">> Building ${VER}"
  docker build --quiet -t panubo/python:${VER}-test .
  popd 1> /dev/null
}

function pull_container {
  VER="$1"
  echo ">> Pulling ${VER}"
  docker pull panubo/python:${VER}
  docker tag panubo/python:${VER} panubo/python:${VER}-test
}

for v in 2.7 3.2 3.3 3.4 3.5 3.6 3.7; do
  [ "${TRAVIS}" == 'true' ] && pull_container ${v} || build_container ${v}
  OUTPUT="$(docker run --rm -ti panubo/python:${v}-test python${v} --version)"
  [[ "${OUTPUT}" == *"Python ${v}"* ]] || { echo "Version test failed. $OUTPUT"; exit 128; } && { echo "> $v OK."; }
done

# All versions test
[ "${TRAVIS}" == 'true' ] && pull_container all || build_container all
for v in 2.7 3.3 3.4 3.5 3.6 3.7; do
  OUTPUT=$(docker run --rm -ti panubo/python:all-test python${v} --version)
  [[ "${OUTPUT}" == *"Python ${v}"* ]] || { echo "Version test failed. $OUTPUT"; exit 128; } && { echo "> $v OK."; }
done
