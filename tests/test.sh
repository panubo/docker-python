#!/usr/bin/env bash

# Build and test all the containers.
# NOBUILD = pull and test the containers
# NB: Does a noisy build in CI environments

set -e
[ "${DEBUG}" == 'true' ] && set -x

function build_container {
  VER="$1"
  pushd ${VER} 1> /dev/null
  echo ">> Building ${VER}"
  if [ "${CI}" == "true" ]; then
    docker build -t panubo/python:${VER}-test .
  else
    docker build --quiet -t panubo/python:${VER}-test .
  fi
  popd 1> /dev/null
}

function pull_container {
  VER="$1"
  echo ">> Pulling ${VER}"
  docker pull panubo/python:${VER}
  docker tag panubo/python:${VER} panubo/python:${VER}-test
}

for v in 2.7 3.2 3.3 3.4 3.5 3.6 3.7; do
  [ "${NOBUILD}" == 'true' ] && pull_container ${v} || build_container ${v}
  OUTPUT="$(docker run --rm -ti panubo/python:${v}-test python${v} --version)"
  [[ "${OUTPUT}" == *"Python ${v}"* ]] || { echo "Version test failed. $OUTPUT"; exit 128; } && { echo "> $v OK."; }
done

# All versions test
[ "${NOBUILD}" == 'true' ] && pull_container all || build_container all
for v in 2.7 3.3 3.4 3.5 3.6 3.7; do
  OUTPUT=$(docker run --rm -ti panubo/python:all-test python${v} --version)
  [[ "${OUTPUT}" == *"Python ${v}"* ]] || { echo "Version test failed. $OUTPUT"; exit 128; } && { echo "> $v OK."; }
done
