#!/usr/bin/env bash

# Build and test all the containers.

set -e
[ "$DEBUG" == 'true' ] && set -x

function build_container {
  VER="$1"
  pushd ${VER} 1> /dev/null
  docker build --quiet -t panubo/python:${VER}-test . 
  popd 1> /dev/null
}

for v in 2.7 3.2 3.3 3.4 3.5 3.6 3.7; do
  build_container ${v}
  OUTPUT=$(docker run --rm -ti panubo/python:${v}-test python${v} --version)
  [[ "${OUTPUT}" = "Python ${v}"* ]] || { echo "Version test failed. $OUTPUT"; exit 128; } && { echo "$v OK."; }
done

# All versions test
build_container all
for v in 2.7 3.3 3.4 3.5 3.6 3.7; do
  OUTPUT=$(docker run --rm -ti panubo/python:all-test python${v} --version)
  [[ "${OUTPUT}" = "Python ${v}"* ]] || { echo "Version test failed. $OUTPUT"; exit 128; } && { echo "$v OK."; }
done
