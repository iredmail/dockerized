#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

# Read variables DOCKER_VOLUME_* from config files.
. ./default_settings.conf
. ./iredmail.conf

for dir in ${DOCKER_VOLUME_SSL_DIR} \
    ${DOCKER_VOLUME_CUSTOM_CONF_DIR} \
    ${DOCKER_VOLUME_MYSQL_DATA_DIR} \
    ${DOCKER_VOLUME_CLAMAV_DB_DIR}; do
    echo "+ Create local volume directory: ${dir}"
    mkdir -p ${dir}
done
