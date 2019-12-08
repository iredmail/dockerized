#!/bin/sh -xv
# Author: Zhang Huangbin <zhb@iredmail.org>

MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD}"
VMAIL_DB_BIND_PASSWORD="${VMAIL_DB_BIND_PASSWORD}"
VMAIL_DB_ADMIN_PASSWORD="${VMAIL_DB_ADMIN_PASSWORD}"

# Create required SQL users and `vmail` database.

echo "Check database 'vmail' (${DATADIR}/vmail)."

if [[ ! -d $DATADIR/vmail ]]; then
    mysql -uroot -p${MYSQL_ROOT_PASSWORD} <<EOF
-- Create users
CREATE USER 'vmail'@'%' IDENTIFIED BY '${VMAIL_DB_BIND_PASSWORD}';
CREATE USER 'vmailadmin'@'%' IDENTIFIED BY '${VMAIL_DB_ADMIN_PASSWORD}';

-- Create database
CREATE DATABASE IF NOT EXISTS vmail CHARACTER SET utf8;

-- Grant permissions
GRANT SELECT ON vmail.* TO 'vmail'@'%';
GRANT SELECT,INSERT,DELETE,UPDATE ON vmail.* TO 'vmailadmin'@'%';

FLUSH PRIVILEGES;
EOF

fi
