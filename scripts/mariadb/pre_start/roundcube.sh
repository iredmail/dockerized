#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

if [[ X"${USE_ROUNDCUBE}" == X"YES" ]]; then

    . /docker/entrypoints/functions.sh

    PRE_START_SCRIPT_DIR="/docker/mariadb/pre_start"

    RC_CONF="/opt/www/roundcubemail/config/config.inc.php"
    CUSTOM_CONF="/opt/iredmail/custom/roundcube/custom.inc.php"
    CUSTOM_CONF_DIR="/opt/iredmail/custom/roundcube"
    DB_NAME="roundcubemail"
    DB_USER="roundcube"

    cmd_mysql="mysql -u root"
    cmd_mysql_db="mysql -u root ${DB_NAME}"
    cd ${PRE_START_SCRIPT_DIR}

    ${cmd_mysql} -e "SHOW DATABASES" |grep "${DB_NAME}" &>/dev/null
    if [[ X"$?" != X'0' ]]; then
        ${cmd_mysql} -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
    fi

    # Make sure sql tables have been created.
    ${cmd_mysql_db} -e "SHOW TABLES" |grep "system" &>/dev/null
    if [[ X"$?" != X'0' ]]; then
        LOG "+ Import /opt/www/roundcubemail/SQL/mysql.initial.sql"
        ${cmd_mysql_db} < /opt/www/roundcubemail/SQL/mysql.initial.sql
    fi

    create_sql_user ${DB_USER} ${ROUNDCUBE_DB_PASSWORD}
    ${cmd_mysql} -e "GRANT ALL ON ${DB_NAME}.* TO '${DB_USER}'@'%' IDENTIFIED BY '${ROUNDCUBE_DB_PASSWORD}'; FLUSH PRIVILEGES;"

    # Update config files.
    ${CMD_SED} "s#PH_SQL_SERVER_ADDRESS#${SQL_SERVER_ADDRESS}#g" ${RC_CONF}
    ${CMD_SED} "s#PH_SQL_SERVER_PORT#${SQL_SERVER_PORT}#g" ${RC_CONF}
    ${CMD_SED} "s#PH_ROUNDCUBE_DB_PASSWORD#${ROUNDCUBE_DB_PASSWORD}#g" ${RC_CONF}
    ${CMD_SED} "s#PH_ROUNDCUBE_DES_KEY#${ROUNDCUBE_DES_KEY}#g" ${RC_CONF}

    create_rc_custom_conf custom.inc.php
    create_rc_custom_conf config_managesieve.inc.php
    create_rc_custom_conf config_markasjunk.inc.php
    create_rc_custom_conf config_password.inc.php

    # Always update SQL db.
    cd /opt/www/roundcubemail-1.4.4 && \
        ./bin/updatedb.sh --dir=./SQL --package roundcube
fi
