#!/usr/bin/env bash

# Build and test all the containers.
# NOBUILD = pull and test the containers
# NB: Does a noisy build in CI environments

set -e
[ "${DEBUG}" == 'true' ] && set -x

CWD="$(dirname $0)/"
source ${CWD}functions.sh

for v in 2.7 3.2 3.3 3.4 3.5 3.6 3.7; do
  [ "${NOBUILD}" == 'true' ] && pull_container "${v}" "-test" || build_container "${v}" "-test"
  test_container "${v}" "${v}-test"
done

# All versions test
[ "${NOBUILD}" == 'true' ] && pull_container all "-test" || build_container all "-test"
for v in 2.7 3.3 3.4 3.5 3.6 3.7; do
  test_container "${v}" "all-test"
done
