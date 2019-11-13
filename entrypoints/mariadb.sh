#!/usr/bin/env sh

DATA_DIR="/var/lib/mysql"
CUSTOM_CONF_DIR="/opt/iredmail/custom/mysql"

if [[ ! -d ${CUSTOM_CONF_DIR} ]]; then
    echo "Create directory used to store custom config files: ${CUSTOM_CONF_DIR}".
    mkdir -p ${CUSTOM_CONF_DIR}
fi

if [[ -d ${DATA_DIR}/mysql ]]; then
    echo "Database `mysql` exists, skip initialization."
else
    echo "Database `mysql` doesn't exist, initializing."
    mysql_install_db
fi

mysqld
