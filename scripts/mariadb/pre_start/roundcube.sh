#!/bin/sh
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

PRE_START_SCRIPT_DIR="/docker/mariadb/pre_start"

RC_CONF="/opt/www/roundcubemail/config/config.inc.php"
DB_NAME="roundcubemail"
DB_USER="roundcube"

. /docker/entrypoints/functions.sh

cmd_mysql="mysql -u root"
cmd_mysql_rc="mysql -u root ${DB_NAME}"
cd ${PRE_START_SCRIPT_DIR}

if [[ X"${USE_ROUNDCUBE}" == X"YES" ]]; then
    ${cmd_mysql} -e "SHOW DATABASES" |grep "${DB_NAME}" &>/dev/null
    if [[ X"$?" != X'0' ]]; then
        ${cmd_mysql} -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
        ${cmd_mysql_rc} < roundcube.initial.mysql
    fi

    create_sql_user ${DB_USER} ${ROUNDCUBE_DB_PASSWORD}
    ${cmd_mysql} -e "GRANT ALL ON ${DB_NAME}.* TO '${DB_USER}'@'%' IDENTIFIED BY '${ROUNDCUBE_DB_PASSWORD}'; FLUSH PRIVILEGES;"

    # Update config files.
    ${CMD_SED} "s#PH_SQL_SERVER_ADDRESS#${SQL_SERVER_ADDRESS}#g" ${RC_CONF}
    ${CMD_SED} "s#PH_SQL_SERVER_PORT#${SQL_SERVER_PORT}#g" ${RC_CONF}
    ${CMD_SED} "s#PH_ROUNDCUBE_DB_PASSWORD#${ROUNDCUBE_DB_PASSWORD}#g" ${RC_CONF}
    ${CMD_SED} "s#PH_ROUNDCUBE_DES_KEY#${ROUNDCUBE_DES_KEY}#g" ${RC_CONF}

    # Always update SQL db.
    cd /opt/www/roundcubemail-1.4.3 && \
        ./bin/updatedb.sh --dir=./SQL --package roundcube
fi
