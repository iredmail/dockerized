#!/bin/sh

# Read variables DOCKER_VOLUME_* from config files.
. ./default_settings.conf
. ./iredmail.conf

for dir in ${DOCKER_VOLUME_SSL_DIR} \
    ${DOCKER_VOLUME_CUSTOM_CONF_DIR} \
    ${DOCKER_VOLUME_DATA_DIR} \
    ${DOCKER_VOLUME_MYSQL_DATA_DIR} \
    ${DOCKER_VOLUME_CLAMAV_DB_DIR}; do
    echo "+ Create local volume directory: ${dir}"
    mkdir -p ${dir}
done
