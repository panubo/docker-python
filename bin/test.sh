#!/usr/bin/env bash

# Build and test all the images.
# NOBUILD = pull and test the images
# NB: Does a noisy build in CI environments

set -e
[ "${DEBUG}" == 'true' ] && set -x

CWD="$(dirname $0)/"
source ${CWD}functions.sh

for v in 2.7 3.2 3.3 3.4 3.5 3.6 3.7; do
  [ "${NOBUILD}" == 'true' ] && pull_image "${v}" "-test" || build_image "${v}" "-test"
  test_image "${v}" "${v}-test"
done

# All versions test
[ "${NOBUILD}" == 'true' ] && pull_image all "-test" || build_image all "-test"
for v in 2.7 3.3 3.4 3.5 3.6 3.7; do
  test_image "${v}" "all-test"
done
