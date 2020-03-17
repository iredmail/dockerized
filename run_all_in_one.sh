#!/bin/sh
# Run the all-in-one container.

# Read variables with default settings.
. ./default_settings.conf

# Read variables with custom settings.
. ./iredmail.conf

# Store all data under this directory on docker host.
data_dir='/opt/iredmail'
[[ -d ${data_dir} ]] || mkdir -p ${data_dir}

docker run \
    --rm \
    --env-file default_settings.conf \
    --env-file iredmail.conf \
    --hostname ${HOSTNAME} \
    -p 80:80 \
    -p 443:443 \
    -p 110:110 \
    -p 995:995 \
    -p 143:143 \
    -p 993:993 \
    -p 25:25 \
    -p 587:587 \
    -v /opt/iredmail:${data_dir} \
    iredmail:latest
