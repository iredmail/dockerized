#!/bin/sh
# Author: Zhang Huangbin <zhb@iredmail.org>
#
# #
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

PRE_START_SCRIPT_DIR="/docker/mariadb/pre_start"

DB_NAME="amavisd"

cmd_mysql="mysql -u root"
cmd_mysql_amavisd="mysql -u root ${DB_NAME}"
cd ${PRE_START_SCRIPT_DIR}

if [[ X"${USE_ANTISPAM}" == X"YES" ]] || [[ X"${USE_IREDAPD}}" == X'YES' ]]; then
    ${cmd_mysql} -e "SHOW DATABASES" |grep "${DB_NAME}" &>/dev/null
    if [[ X"$?" != X'0' ]]; then
        ${cmd_mysql} -e "CREATE DATABASE IF NOT EXISTS amavisd DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
        ${cmd_mysql_amavisd} < amavisd.mysql
    fi

    create_sql_user amavisd ${AMAVISD_DB_PASSWORD}
    ${cmd_mysql} -e "GRANT SELECT,INSERT,UPDATE,DELETE ON amavisd.* TO 'amavisd'@'%'; FLUSH PRIVILEGES;"

    ${cmd_mysql_amavisd} -e "SELECT id FROM policy WHERE policy_name='@.' LIMIT 1" | grep 'id' &>/dev/null
    if [[ X"$?" != X'0' ]]; then
        ${cmd_mysql_amavisd} < default_spam_policy.mysql
    fi
fi
