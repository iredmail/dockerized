#!/usr/bin/env bash
# Purpose: Build image for single application.
# Usage:
#
#   ./build.sh          # Build with `Dockerfiles/Dockerfile`
#   ./build.sh <name>   # name of file under `Dockerfiles/`.

f="$1"
shift

if [[ X"${f}" == X"" ]]; then
    df="Dockerfiles/Dockerfile"
    label="iredmail-core"
else
    df="Dockerfiles/${f}"
    label="iredmail-${f}"
fi

[[ -f ${df} ]] || (echo "Docker file ${df} doesnt exist." && exit 255)

docker build \
    --tag ${label}:dev \
    -f ${df} .
