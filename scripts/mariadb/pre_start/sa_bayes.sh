#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

. /docker/entrypoints/functions.sh

PRE_START_SCRIPT_DIR="/docker/mariadb/pre_start"

DB_NAME="sa_bayes"
DB_USER="sa_bayes"

cmd_mysql="mysql -u root"
cmd_mysql_db="mysql -u root ${DB_NAME}"
cd ${PRE_START_SCRIPT_DIR}

if [[ X"${USE_ANTISPAM}" == X"YES" ]] || [[ X"${USE_IREDAPD}}" == X'YES' ]]; then
    ${cmd_mysql} -e "SHOW DATABASES" |grep "${DB_NAME}" &>/dev/null
    if [[ X"$?" != X'0' ]]; then
        LOG "+ Create database ${DB_NAME}."
        ${cmd_mysql} -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
    fi

    # Make sure sql tables have been created.
    ${cmd_mysql_db} -e "SHOW TABLES" |grep "bayes_vars" &>/dev/null
    if [[ X"$?" != X'0' ]]; then
        LOG "+ Import sa_bayes.mysql"
        ${cmd_mysql_db} < sa_bayes.mysql
    fi

    create_sql_user ${DB_USER} ${SA_BAYES_DB_PASSWORD}
    ${cmd_mysql} -e "GRANT ALL ON ${DB_NAME}.* TO '${DB_USER}'@'%'; FLUSH PRIVILEGES;"
fi
