#!/bin/sh

# TODO
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
CUSTOM_CONF_DIR="/opt/iredmail/custom/mysql"
SOCKET_PATH="/var/run/mysqld/mysqld.sock"
DOT_MY_CNF="/root/.my.cnf"

# Directories used to store pre-start and initialization shell/sql scripts.
PRE_START_SCRIPTS_DIR="/docker/mariadb/pre_start"
FIRST_RUN_SCRIPTS_DIR="/docker/mariadb/first_run"

. /docker/entrypoints/functions.sh

if [[ ! -d ${CUSTOM_CONF_DIR} ]]; then
    LOG "Create directory used to store custom config files: ${CUSTOM_CONF_DIR}".
    mkdir -p ${CUSTOM_CONF_DIR}
fi

# Create data directory if not present
[[ -d ${DATA_DIR} ]] || mkdir -p ${DATA_DIR}

MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD}"
MYSQL_USE_RANDOM_ROOT_PASSWORD="${MYSQL_USE_RANDOM_ROOT_PASSWORD:=NO}"

if [[ -z "$MYSQL_ROOT_PASSWORD" ]] && [[ "$MYSQL_USE_RANDOM_ROOT_PASSWORD" == "NO" ]]; then
    if [[ ! -d "${DATA_DIR}/mysql" ]]; then
        LOG_ERROR "Database is uninitialized due to password option is not specified."
    fi

    LOG_ERROR "Please specify one of MYSQL_ROOT_PASSWORD and MYSQL_USE_RANDOM_ROOT_PASSWORD."
    exit 255
fi

# Configure root password
if [[ "$MYSQL_USE_RANDOM_ROOT_PASSWORD" == "YES" ]]; then
    LOG "Generate random root password. Will be saved in ${DOT_MY_CNF}."
    export MYSQL_ROOT_PASSWORD="$(pwgen -c -n -s -B -v -1 32)"
fi

cmd_mysql_opts="--protocol=socket -uroot -hlocalhost --socket=${SOCKET_PATH}"
cmd_mysql="mysql ${cmd_mysql_opts}"
cmd_mysql_with_dot_cnf="mysql --defaults-file=${DOT_MY_CNF} ${cmd_mysql_opts}"

start_temp_mysql_instance() {
    LOG "Starting temporary MariaDB instance."
    mysqld --skip-networking --skip-grant-tables --datadir="${DATA_DIR}" --socket="${SOCKET_PATH}" &
    _pid="$!"
    echo "${_pid}" > /tmp/temp_instance_pid

    # Wait until MariaDB instance is started
    LOG "Waiting for MariaDB service ..."
    for i in $(seq 30); do
        if mysqladmin --socket="${SOCKET_PATH}" ping &>/dev/null; then
            break
        fi

        sleep 1

        if [[ "$i" == 30 ]]; then
            LOG "Initialization failed. Please check ${DATA_DIR}/mysqld.err for more details."
            exit 255
        fi
    done
}

stop_temp_mysql_instance() {
    # Stop the temporary mysql instance
    _pid="$(cat /tmp/temp_instance_pid)"

    if ! kill -s TERM "${_pid}" || ! wait "${_pid}"; then
        LOG_ERROR "Failed to stop temporary MariaDB instance."
        exit 255
    fi

    rm -f /tmp/temp_instance_pid
}

create_root_user() {
    _file="$(mktemp -u)"
    _grant_host='%'

    cat <<-EOF > ${_file}
-- What's done in this file shouldn't be replicated
-- or products like mysql-fabric won't work
SET @@SESSION.SQL_LOG_BIN=0;
DELETE FROM mysql.user WHERE user NOT IN ('mysql.sys', 'mysqlxsys', 'root', 'mysql') OR host NOT IN ('localhost') ;
SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_ROOT_PASSWORD}') ;
GRANT ALL ON *.* TO 'root'@'localhost' WITH GRANT OPTION ;

CREATE USER 'root'@'${_grant_host}' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;
GRANT ALL ON *.* TO 'root'@'${_grant_host}' WITH GRANT OPTION ;

DROP DATABASE IF EXISTS test ;
FLUSH PRIVILEGES ;
EOF

    if [[ -f ${DOT_MY_CNF} ]]; then
        _cmd_mysql="${cmd_mysql_with_dot_cnf}"
    else
        _cmd_mysql="${cmd_mysql}"
    fi

    LOG "Create MariaDB root user."
    sh -c "${_cmd_mysql} < ${_file}"
    rm -f ${_file}
}

reset_root_password() {
    LOG "Reset MariaDB root password."
    mysql -u root --socket=${SOCKET_PATH} -e "USE mysql; UPDATE user SET Password=password('${MYSQL_ROOT_PASSWORD}'),authentication_string=password('${MYSQL_ROOT_PASSWORD}') WHERE User='root'; FLUSH PRIVILEGES;"
}

create_dot_my_cnf() {
    cat <<EOF > ${DOT_MY_CNF}
[client]
host=localhost
user=root
password="${MYSQL_ROOT_PASSWORD}"
socket="${SOCKET_PATH}"
EOF

}

# Run all .sh/.sql/.sql.gz scripts in given directory.
run_scripts_in_dir() {
    _dir="${1}"

    if [[ -f ${DOT_MY_CNF} ]]; then
        _cmd_mysql="${cmd_mysql_with_dot_cnf}"
    else
        _cmd_mysql="${cmd_mysql}"
    fi

    if [[ -d ${_dir} ]] && [[ "$(ls -A ${_dir})" ]]; then
        for f in ${_dir}/*; do
            case "$f" in
                *.sh)
                    LOG "[Run] $f"
                    . "$f"
                    ;;
                *.sql|*.mysql)
                    LOG "[Run] $f"
                    sh -c "${_cmd_mysql}" < "$f"
                    ;;
                *.sql.gz)
                    LOG "[Run] $f"
                    gunzip -c "$f" | "${_cmd_mysql@}"
                    ;;
                *) LOG "[Ignore] $f. Only *.[sh|sql|mysql|sql.gz] are supported." ;;
            esac
        done
    fi
}

# Create directory used to store socket/pid files.
install -d -o ${USER} -g ${GROUP} -m 0755 $(dirname ${SOCKET_PATH})

_first_run="NO"
_run_pre_start="NO"

# Initialize database
if [[ ! -d "${DATA_DIR}/mysql" ]]; then
    _first_run="YES"

    LOG "Initializing database ..."
    mysql_install_db --user=${USER} --datadir="${DATA_DIR}" >/dev/null
fi

if [[ -d "${PRE_START_SCRIPTS_DIR}" ]] && [[ "$(ls -A ${PRE_START_SCRIPTS_DIR})" ]]; then
    _run_pre_start="YES"
fi

if [[ "${_first_run}" == "YES" ]] || [[ "${_run_pre_start}" == "YES" ]]; then
    start_temp_mysql_instance
fi

if [[ "${_first_run}" == "YES" ]]; then
    create_root_user
    create_dot_my_cnf
    run_scripts_in_dir ${FIRST_RUN_SCRIPTS_DIR}
fi

if [[ "${_run_pre_start}" == "YES" ]]; then
    if [[ "${_first_run}" != "YES" ]]; then
        reset_root_password
        create_dot_my_cnf
    fi

    run_scripts_in_dir ${PRE_START_SCRIPTS_DIR}
fi

if [[ "${_first_run}" == "YES" ]] || [[ "${_run_pre_start}" == "YES" ]]; then
    stop_temp_mysql_instance
fi

#if [[ X"$1" == X'--background' ]]; then
#    shift 1
#    mysqld_safe --user=${USER} --datadir="${DATA_DIR} $@ &
#else
#    mysqld_safe --user=${USER} --datadir="${DATA_DIR} $@
#fi
