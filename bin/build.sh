#!/usr/bin/env bash

# Build and push all the images.

set -e
[ "${DEBUG}" == 'true' ] && set -x

CWD="$(dirname $0)/"
source ${CWD}functions.sh

for v in 2.7 3.2 3.3 3.4 3.5 3.6 3.7 all; do
  build_image ${v} ""
  push_image ${v}
done
