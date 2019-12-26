#!/bin/sh
# Run the all-in-one container.

# Read variables DOCKER_VOLUME_* from config files.
. ./default_settings.conf
. ./iredmail.conf

for dir in ${DOCKER_VOLUME_BASEDIR} \
    ${DOCKER_VOLUME_CUSTOM_CONF_DIR} \
    ${DOCKER_VOLUME_DATA_DIR} \
    ${DOCKER_VOLUME_SSL_DIR} \
    ${DOCKER_VOLUME_MAILBOXES_DIR} \
    ${DOCKER_VOLUME_MYSQL_DATA_DIR} \
    ${DOCKER_VOLUME_CLAMAV_DB_DIR} \
    ${DOCKER_VOLUME_MLMMJ_DATA_DIR} \
    ${DOCKER_VOLUME_MLMMJ_ARCHIVE_DIR} \
    ${DOCKER_VOLUME_IMAPSIEVE_COPY_DIR} \
    ${DOCKER_VOLUME_SPAMASSASSIN_RULE_DIR}; do
    if [ ! -d ${dir} ]; then
        echo "+ Create local volume directory: ${dir}"
        mkdir -p ${dir}
    fi
done

docker run \
    --rm \
    --env-file default_settings.conf \
    --env-file iredmail.conf \
    -v ${DOCKER_VOLUME_CUSTOM_CONF_DIR}:/opt/iredmail/custom \
    -v ${DOCKER_VOLUME_DATA_DIR}:/opt/iredmail/data \
    -v ${DOCKER_VOLUME_SSL_DIR}:/opt/iredmail/ssl \
    -v ${DOCKER_VOLUME_MAILBOXES_DIR}:/var/vmail/vmail1 \
    -v ${DOCKER_VOLUME_MYSQL_DATA_DIR}:/var/lib/mysql \
    -v ${DOCKER_VOLUME_CLAMAV_DB_DIR}:/var/lib/clamav \
    -v ${DOCKER_VOLUME_MLMMJ_DATA_DIR}:/var/vmail/mlmmj \
    -v ${DOCKER_VOLUME_MLMMJ_ARCHIVE_DIR}:/var/vmail/mlmmj-archive \
    -v ${DOCKER_VOLUME_IMAPSIEVE_COPY_DIR}:/var/vmail/imapsieve_copy \
    -v ${DOCKER_VOLUME_SPAMASSASSIN_RULE_DIR}:/var/lib/spamassassin \
    iredmail:latest
