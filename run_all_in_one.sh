#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>
# Purpose: Run the all-in-one container.

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

PWD="$(pwd)"
CONF="${PWD}/iredmail-docker.conf"
DATA_DIR="${PWD}/data"

if [[ ! -e ${CONF} ]]; then
    echo "ERROR: Config file ${CONF} doesn't exist."
    echo "ERROR: Please create it first."
    exit 255
fi

. ${CONF}

DATA_SUB_DIRS='
    backup-mysql
    clamav
    custom
    imapsieve_copy
    mailboxes
    mlmmj
    mlmmj-archive
    mysql
    postfix_queue
    sa_rules
    ssl
'

for i in ${DATA_SUB_DIRS}; do
    _dir="${DATA_DIR}/${i}"
    if [ ! -d ${_dir} ]; then
        echo "+ Create local volume directory: ${_dir}"
        mkdir -p ${_dir}
    fi
done

docker run \
    --rm \
    --env-file ${CONF} \
    --hostname ${HOSTNAME} \
    -p 80:80 \
    -p 443:443 \
    -p 110:110 \
    -p 995:995 \
    -p 143:143 \
    -p 993:993 \
    -p 25:25 \
    -p 587:587 \
    -v ${DATA_DIR}/custom:/opt/iredmail/custom \
    -v ${DATA_DIR}/ssl:/opt/iredmail/ssl \
    -v ${DATA_DIR}/backup-mysql:/var/vmail/backup/mysql \
    -v ${DATA_DIR}/mailboxes:/var/vmail/vmail1 \
    -v ${DATA_DIR}/mysql:/var/lib/mysql \
    -v ${DATA_DIR}/clamav:/var/lib/clamav \
    -v ${DATA_DIR}/mlmmj:/var/vmail/mlmmj \
    -v ${DATA_DIR}/mlmmj-archive:/var/vmail/mlmmj-archive \
    -v ${DATA_DIR}/imapsieve_copy:/var/vmail/imapsieve_copy \
    -v ${DATA_DIR}/sa_rules:/var/lib/spamassassin \
    -v ${DATA_DIR}/postfix_queue:/var/spool/postfix \
    iredmail/mariadb:nightly
