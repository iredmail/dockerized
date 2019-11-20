#!/usr/bin/env bash
# Usage: ./run.sh <image-id>

# Image ID or name.
image_id="${1}"

if [[ $# == 1 ]]; then
    cmd="/bin/sh"
else
    cmd="$@"
fi

# Run single image with pre-defined volumes.
docker-compose run --entrypoint ${cmd} ${image_id}
