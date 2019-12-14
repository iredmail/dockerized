#!/bin/sh

# Read variables DOCKER_VOLUME_* from iredmail.conf and `env.defaults`.
. ./env.defaults
. ./iredmail.conf

for dir in ${DOCKER_VOLUME_SSL} \
    ${DOCKER_VOLUME_CUSTOM_CONF_DIR} \
    ${DOCKER_VOLUME_DATA_DIR} \
    ${DOCKER_VOLUME_MYSQL_DB} \
    ${DOCKER_VOLUME_CLAMAV_DB}; do
    echo "+ Create local volume directory: ${dir}"
    mkdir -p ${dir}
done
