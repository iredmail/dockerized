#!/usr/bin/env sh

# TODO
#   - put socket/pid files under /run/mysql/
#   - Set root password: mysqladmin password "my_new_password"
#   - Create /root/.my.cnf
#   - Delete anonymous user
#   - Drop 'test' database

USER="mysql"
GROUP="mysql"
DATA_DIR="/var/lib/mysql"
SOCKET_PATH="/var/lib/mysql/mysql.sock"
CUSTOM_CONF_DIR="/opt/iredmail/custom/mysql"

LOG() {
    echo "[iRedMail] $@"
}

if [[ -z "${MYSQL_ROOT_PASSWORD}" ]]; then
    LOG "ERROR: Variable MYSQL_ROOT_PASSWORD is empty."
    exit 255
fi

if [[ ! -d ${CUSTOM_CONF_DIR} ]]; then
    LOG "Create directory used to store custom config files: ${CUSTOM_CONF_DIR}".
    mkdir -p ${CUSTOM_CONF_DIR}
fi

[[ -d ${DATA_DIR} ]] || mkdir -p ${DATA_DIR}

if [[ ! -d ${DATA_DIR}/mysql ]]; then
    LOG "Database 'mysql' doesn't exist, initializing."
    mysql_install_db --datadir="${DATA_DIR}"
fi

LOG "Run mysql service..."
mysqld_safe --user=${USER} --console "$@"
