#!/bin/bash
# Author: ChangWuk Kim <changwuk@xyneuron.com>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# but I modify it manually...
#

. /docker/entrypoints/functions.sh

PRE_START_SCRIPT_DIR="/docker/mariadb/pre_start"

DB_NAME="sogo"
DB_USER="sogo"

cmd_mysql="mysql -u root"
cmd_mysql_db="mysql -u root ${DB_NAME}"
cd ${PRE_START_SCRIPT_DIR}

if [[ X"${USE_SOGO}" == X'YES' ]]; then
    ${cmd_mysql} -e "SHOW DATABASES" |grep "${DB_NAME}" &>/dev/null
    if [[ X"$?" != X'0' ]]; then
        LOG "+ Create database ${DB_NAME}."
        ${cmd_mysql} -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci; CREATE VIEW ${DB_NAME}.users (c_uid, c_name, c_password, c_cn, mail, domain, c_webmail, c_calendar, c_activesync) AS SELECT username, username, password, name, username, domain, enablesogowebmail, enablesogocalendar, enablesogoactivesync FROM vmail.mailbox WHERE enablesogo=1 AND active=1;"
    fi

    # Allow user to update password.
    create_sql_user ${DB_USER} ${SOGO_DB_PASSWORD}
    ${cmd_mysql} -e "GRANT ALL ON ${DB_NAME}.* TO ${DB_NAME}@'%' IDENTIFIED BY '${SOGO_DB_PASSWORD}'; GRANT SELECT ON vmail.mailbox TO ${DB_NAME}@'%'; FLUSH PRIVILEGES;"
fi
