#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

. /docker/entrypoints/functions.sh

PRE_START_SCRIPT_DIR="/docker/mariadb/pre_start"

cmd_mysql="mysql --defaults-file=/root/.my.cnf -u root"
cmd_mysql_db="${cmd_mysql} vmail"
cd ${PRE_START_SCRIPT_DIR}

# Create required SQL users and `vmail` database.
create_sql_user vmail ${VMAIL_DB_PASSWORD}
create_sql_user vmailadmin ${VMAIL_DB_ADMIN_PASSWORD}

# Create database.
${cmd_mysql_db} -e "SHOW TABLES" &>/dev/null
if [[ X"$?" != X'0' ]]; then
    LOG "Create database 'vmail' and tables."
    ${cmd_mysql} -e "CREATE DATABASE vmail CHARACTER SET utf8;"
    ${cmd_mysql} < iredmail.mysql
fi

LOG "Grant privileges to SQL user 'vmail' and 'vmailadmin'."
${cmd_mysql_db} <<EOF
GRANT SELECT ON vmail.* TO 'vmail'@'%';
GRANT SELECT,INSERT,DELETE,UPDATE ON vmail.* TO 'vmailadmin'@'%';
FLUSH PRIVILEGES;
EOF

# Add first mail domain.
${cmd_mysql_db} -e "SELECT domain FROM domain WHERE domain='${FIRST_MAIL_DOMAIN}' LIMIT 1" | grep 'domain' &>/dev/null
if [[ X"$?" != X'0' ]]; then
    LOG "Create first mail domain: ${FIRST_MAIL_DOMAIN}."
    ${cmd_mysql_db} -e "INSERT INTO domain (domain, transport) VALUES ('${FIRST_MAIL_DOMAIN}', 'dovecot')"
fi

# Always add/reset POSTMASTER_EMAIL as a global admin.
_admin="postmaster@${FIRST_MAIL_DOMAIN}"
_pw="${FIRST_MAIL_DOMAIN_ADMIN_PASSWORD}"

_pw_hash="{CRYPT}$(echo ${_pw} | openssl passwd -6 -stdin)"

${cmd_mysql_db} -e "SELECT username FROM mailbox WHERE username='${_admin}' LIMIT 1" | grep 'username' &>/dev/null
if [[ X"$?" != X'0' ]]; then
    LOG "Add user ${_admin}."
    ${cmd_mysql_db} <<EOF
INSERT INTO mailbox (username,
                     password,
                     storagebasedirectory,
                     storagenode,
                     maildir,
                     quota,
                     domain,
                     isadmin,
                     isglobaladmin)
             VALUES ('${_admin}',
                     '${_pw_hash}',
                     '/var/vmail',
                     'vmail1',
                     '${FIRST_MAIL_DOMAIN}/postmaster/',
                     0,
                     '${FIRST_MAIL_DOMAIN}',
                     1,
                     1);
EOF
fi

# Make sure forwarding exists, but not remove existing forwardings.
${cmd_mysql_db} -e "SELECT address FROM forwardings WHERE address='${_admin}' LIMIT 1" | grep 'address' &>/dev/null
if [[ X"$?" != X'0' ]]; then
    LOG "Add (internal) mail forwarding for ${_admin}."
    ${cmd_mysql_db} <<EOF
INSERT INTO forwardings (address, forwarding, domain, dest_domain, is_forwarding)
                 VALUES ('${_admin}', '${_admin}', '${FIRST_MAIL_DOMAIN}', '${FIRST_MAIL_DOMAIN}', 1);
EOF
fi

LOG "Make sure ${_admin} is a global admin."
${cmd_mysql_db} <<EOF
DELETE FROM domain_admins WHERE username='${_admin}';
INSERT INTO domain_admins (username, domain, active) VALUES ('${_admin}', 'ALL', 1);
EOF
