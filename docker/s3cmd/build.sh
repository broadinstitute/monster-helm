#!/usr/bin/env bash
set -euo pipefail

declare -r SCRIPT_DIR=$(cd $(dirname ${0}) >/dev/null 2>&1 && pwd)
declare -r VERSION=1.0.0

docker build --build-arg S3CMD_VERSION=2.1.0 -t us.gcr.io/broad-dsp-gcr-public/s3cmd:${VERSION} ${SCRIPT_DIR}
docker push us.gcr.io/broad-dsp-gcr-public/s3cmd:${VERSION}
