#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

. /docker/entrypoints/functions.sh

PRE_START_SCRIPT_DIR="/docker/mariadb/pre_start"

DB_NAME="amavisd"
DB_USER="amavisd"

cmd_mysql="mysql -u root"
cmd_mysql_amavisd="mysql -u root ${DB_NAME}"
cd ${PRE_START_SCRIPT_DIR}

if [[ X"${USE_ANTISPAM}" == X"YES" ]] || [[ X"${USE_IREDAPD}}" == X'YES' ]]; then
    ${cmd_mysql} -e "SHOW DATABASES" |grep "${DB_NAME}" &>/dev/null
    if [[ X"$?" != X'0' ]]; then
        LOG "+ Create database ${DB_NAME}."
        ${cmd_mysql} -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
        ${cmd_mysql_amavisd} < amavisd.mysql
    fi

    create_sql_user ${DB_USER} ${AMAVISD_DB_PASSWORD}
    ${cmd_mysql} -e "GRANT SELECT,INSERT,UPDATE,DELETE ON ${DB_NAME}.* TO '${DB_USER}'@'%'; FLUSH PRIVILEGES;"

    # Default global spam policy.
    ${cmd_mysql_amavisd} -e "SELECT id FROM policy WHERE policy_name='@.' LIMIT 1" | grep 'id' &>/dev/null
    if [[ X"$?" != X'0' ]]; then
        LOG "+ Create default spam policy."
        ${cmd_mysql_amavisd} < default_spam_policy.mysql
    fi
fi
