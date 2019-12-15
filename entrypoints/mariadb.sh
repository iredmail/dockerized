#!/usr/bin/env sh

# TODO
#   - (re)set root password: mysqladmin password "my_new_password"
#   - Create /root/.my.cnf
#   - Delete anonymous user
#   - Drop 'test' database

# Optional command line arguments supported by this script:
#
#   --background: Run mysql in background.
#                 Note: must be first argument on command line..
#
# All other arguments specified on command line will be passed to `mysqld_safe`
# command (and eventually passed to `mysqld`).

USER="mysql"
GROUP="mysql"
DATA_DIR="/var/lib/mysql"
SOCKET_PATH="/var/run/mysqld/mysqld.sock"
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

install -d -o ${USER} -g root -m 0755 /var/run/mysqld

if [[ ! -d ${DATA_DIR}/mysql ]]; then
    LOG "Database 'mysql' doesn't exist, initializing."
    mysql_install_db --datadir="${DATA_DIR}"
fi

LOG "Run mysql service..."

if [[ X"$1" == X'--background' ]]; then
    shift 1
    mysqld_safe --user=${USER} $@ &
else
    mysqld_safe --user=${USER} $@
fi
