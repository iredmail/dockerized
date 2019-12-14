#!/usr/bin/env sh

# TODO
#   - put socket/pid files under /run/mysql/

USER="mysql"
GROUP="mysql"
DATA_DIR="/var/lib/mysql"
CUSTOM_CONF_DIR="/opt/iredmail/custom/mysql"

if [[ ! -d ${CUSTOM_CONF_DIR} ]]; then
    echo "Create directory used to store custom config files: ${CUSTOM_CONF_DIR}".
    mkdir -p ${CUSTOM_CONF_DIR}
fi

[[ -d ${DATA_DIR} ]] || mkdir -p ${DATA_DIR}

#_uid="$(stat -c "%u" ${DATA_DIR})"
#_gid="$(stat -c "%g" ${DATA_DIR})"

#echo "Owner/group id of data directory: ${_uid}:${_gid}."
#usermod -o -u ${_uid} ${USER} || true
#groupmod -o -g ${_gid} ${USER} || true

#user="$(id -u)"
#if [[ "$user" == "0" ]]; then
#    chown -R ${USER} ${DATA_DIR}
#
#    # this will cause less disk access than `chown -R`
#    #find "${DATA_DIR}" \! -user mysql -exec chown mysql '{}' +
#fi

if [[ ! -d ${DATA_DIR}/mysql ]]; then
    echo "Database 'mysql' doesn't exist, initializing."
    mysql_install_db --datadir="${DATA_DIR}"

    # TODO
    #   - Set root password: mysqladmin password "my_new_password"
    #   - Create /root/.my.cnf
    #   - Delete anonymous user
    #   - Drop 'test' database
    #if [[ -z "$MYSQL_ROOT_PASSWORD" ]]; then
       #       echo "Database is uninitialized and root password is not specified with MYSQL_ROOT_PASSWORD."
       #fi
fi

echo "Run mysql service..."
#mysqld_safe
mysqld_safe --user=${USER} --console
