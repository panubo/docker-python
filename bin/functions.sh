#!/usr/bin/env bash

function build_image {
  VERSION="$1"
  SUFFIX="$2"
  pushd ${VERSION} 1> /dev/null
  echo ">> Building ${VERSION} as ${VERSION}${SUFFIX}"
  if [ "${CI}" == "true" ]; then
    docker build -t panubo/python:${VERSION}${SUFFIX} .
  else
    docker build --quiet -t panubo/python:${VERSION}${SUFFIX} .
  fi
  popd 1> /dev/null
}

function pull_image {
  VERSION="$1"
  SUFFIX="$2"
  echo ">> Pulling ${VERSION}"
  docker pull panubo/python:${VERSION}
  docker tag panubo/python:${VERSION} panubo/python:${VERSION}${SUFFIX}
}

function push_image {
  TAG="$1"
  echo ">> Pushing ${TAG}"
  docker push panubo/python:${TAG}
}

function test_image {
  VERSION="$1"
  TAG="$2"
  OUTPUT="$(docker run --rm -ti panubo/python:${TAG} python${VERSION} --version)"
  [[ "${OUTPUT}" == *"Python ${VERSION}"* ]] || { echo "Version test failed. $OUTPUT"; exit 128; } && { echo "> ${VERSION} OK."; }
}
