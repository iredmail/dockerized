#!/bin/sh -xv
# Author: Zhang Huangbin <zhb@iredmail.org>

PRE_START_SCRIPT_DIR="/docker/mariadb/pre_start"

. /docker/entrypoints/functions.sh

cmd_mysql="mysql -u root"
cd ${PRE_START_SCRIPT_DIR}

# Create required SQL users and `vmail` database.
create_sql_user vmail ${VMAIL_DB_PASSWORD}
create_sql_user vmailadmin ${VMAIL_DB_ADMIN_PASSWORD}

# Create database.
${cmd_mysql} vmail -e "SHOW TABLES" &>/dev/null
if [[ X"$?" != X'0' ]]; then
    ${cmd_mysql} -e "CREATE DATABASE vmail CHARACTER SET utf8;"
    ${cmd_mysql} < iredmail.mysql
fi

# Grant permissions.
${cmd_mysql} <<EOF
GRANT SELECT ON vmail.* TO 'vmail'@'%';
GRANT SELECT,INSERT,DELETE,UPDATE ON vmail.* TO 'vmailadmin'@'%';
FLUSH PRIVILEGES;
EOF
