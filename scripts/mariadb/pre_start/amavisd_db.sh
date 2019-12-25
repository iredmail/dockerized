#!/bin/sh

PRE_START_SCRIPT_DIR="/docker/mariadb/pre_start"

cmd_mysql="mysql -u root"
cd ${PRE_START_SCRIPT_DIR}

if [[ X"${USE_ANTISPAM}" == X"YES" ]]; then
    ${cmd_mysql} -e "CREATE DATABASE IF NOT EXISTS amavisd DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"

    ${cmd_mysql} amavisd < amavisd.mysql
    create_sql_user amavisd ${AMAVISD_DB_PASSWORD}
    ${cmd_mysql} -e "GRANT SELECT,INSERT,UPDATE,DELETE ON amavisd.* TO 'amavisd'@'%'; FLUSH PRIVILEGES;"

    ${cmd_mysql} -e "SELECT id FROM policy WHERE policy_name='@.' LIMIT 1" | grep 'id'
    if [[ X"$?" != X'0' ]]; then
        ${cmd_mysql} < default_spam_policy.mysql
    fi
fi
