#!/usr/bin/env sh
# Author: Zhang Huangbin <zhb@iredmail.org>

. /docker/entrypoints/functions.sh

POSTMASTER_EMAIL="${POSTMASTER_EMAIL:=postmaster@${FIRST_MAIL_DOMAIN}}"

# SSL cert.
SSL_CERT_DIR='/opt/iredmail/ssl'
SSL_CERT_FILE='/opt/iredmail/ssl/cert.pem'
SSL_KEY_FILE='/opt/iredmail/ssl/key.pem'
SSL_COMBINED_FILE='/opt/iredmail/ssl/combined.pem'
SSL_KEY_LENGTH='4096'
SSL_CERT_COUNTRY='SI'
SSL_CERT_STATE='Domzale'
SSL_CERT_CITY='Domzale'
SSL_CERT_DEPARTMENT='IT'
SSL_DHPARAM2048_FILE='/opt/iredmail/ssl/dhparam2048.pem'

DOVECOT_CONF="/etc/dovecot/dovecot.conf"
DOVECOT_USERDB_CONF="/etc/dovecot/dovecot-mysql.conf"
DOVECOT_CONF_DIR="/etc/dovecot"
DOVECOT_AVAILABLE_CONF_DIR="/etc/dovecot/conf-available"
DOVECOT_ENABLED_CONF_DIR="/etc/dovecot/conf-enabled"
DOVECOT_CONF_MASTER_USERS="/etc/dovecot/dovecot-master-users"

# Custom config files.
DOVECOT_CUSTOM_CONF_DIR="/opt/iredmail/custom/dovecot"
DOVECOT_CUSTOM_ENABLED_CONF_DIR="/opt/iredmail/custom/dovecot/conf-enabled"
DOVECOT_CUSTOM_GLOBAL_SIEVE_FILE="/opt/iredmail/custom/dovecot/dovecot.sieve"
DOVECOT_CUSTOM_CONF_MASTER_USERS="/opt/iredmail/custom/dovecot/master-users"

# Create required directories
for d in ${MAILBOXES_DIR} \
    ${SSL_CERT_DIR} \
    ${DOVECOT_CUSTOM_CONF_DIR} \
    ${DOVECOT_CUSTOM_ENABLED_CONF_DIR} \
    ${DOVECOT_ENABLED_CONF_DIR}; do
    [[ -d ${d} ]] || mkdir -p ${d}
done

# Create self-signed ssl cert.
if [[ ! -f ${SSL_CERT_FILE} ]] || [[ ! -f ${SSL_KEY_FILE} ]]; then
    LOG "Generating self-signed ssl cert under ${SSL_CERT_DIR}."
    openssl req -x509 -nodes -sha256 -days 3650 \
        -subj "/C=${SSL_CERT_COUNTRY}/ST=${SSL_CERT_STATE}/L=${SSL_CERT_CITY}/O=${SSL_CERT_DEPARTMENT}/CN=${HOSTNAME}/emailAddress=${POSTMASTER_EMAIL}" \
        -newkey rsa:${SSL_KEY_LENGTH} \
        -out ${SSL_CERT_FILE} \
        -keyout ${SSL_KEY_FILE} >/dev/null

    cp -f ${SSL_CERT_FILE} ${SSL_COMBINED_FILE}
fi
chmod 0644 ${SSL_CERT_FILE} ${SSL_KEY_FILE} ${SSL_COMBINED_FILE}

# Create dh param.
if [[ ! -f ${SSL_DHPARAM2048_FILE} ]]; then
    LOG "Generating dh param file: ${SSL_DHPARAM2048_FILE}. It make take a long time."
    openssl dhparam -out ${SSL_DHPARAM2048_FILE} 2048 >/dev/null
fi
chmod 0644 ${SSL_DHPARAM2048_FILE}

# Make sure mailboxes directory has correct owner/group and permission.
# Note: If there're many mailboxes, `chown/chmod -R` will take a long time.
chown ${SYS_USER_VMAIL}:${SYS_GROUP_VMAIL} ${MAILBOXES_DIR}
chmod 0700 ${MAILBOXES_DIR}

# Enable some modular config files.
for f in service-imap-hibernate.conf stats.conf; do
    ln -s ${DOVECOT_AVAILABLE_CONF_DIR}/${f} ${DOVECOT_ENABLED_CONF_DIR}/${f}
done

# Must be readable by `vmail` user which runs Dovecot LDA as Postfix transport.
touch_files ${SYS_USER_ROOT} ${SYS_GROUP_ROOT} 0644 ${DOVECOT_CONF}
touch_files ${SYS_USER_DOVECOT} ${SYS_GROUP_DOVECOT} 0640 \
    ${DOVECOT_USERDB_CONF} \
    /etc/dovecot/dovecot-used-quota.conf \
    /etc/dovecot/dovecot-last-login.conf \
    /etc/dovecot/dovecot-share-folder.conf \
    /etc/dovecot/dovecot-master-users \
    ${DOVECOT_CONF_MASTER_USERS} \
    ${DOVECOT_CUSTOM_CONF_MASTER_USERS}

touch_files ${SYS_USER_VMAIL} ${SYS_GROUP_VMAIL} 0700 ${DOVECOT_CUSTOM_GLOBAL_SIEVE_FILE}

# Set proper owner/group and permissions.
chown -R ${SYS_USER_VMAIL}:${SYS_GROUP_VMAIL} \
    /opt/iredmail/bin/dovecot/scan_reported_mails \
    /opt/iredmail/bin/dovecot/sieve
chmod 0550 /opt/iredmail/bin/dovecot/scan_reported_mails /opt/iredmail/bin/dovecot/sieve/*

# Update parameters.
${CMD_SED} "s#PH_HOSTNAME#${HOSTNAME}#g" /opt/iredmail/bin/dovecot/scan_reported_mails /opt/iredmail/bin/dovecot/sieve/imapsieve_copy /opt/iredmail/bin/dovecot/quota_warning.sh

${CMD_SED} "s#PH_SQL_SERVER_ADDRESS#${SQL_SERVER_ADDRESS}#g" ${DOVECOT_USERDB_CONF} ${DOVECOT_CONF_DIR}/*.conf
${CMD_SED} "s#PH_SQL_SERVER_PORT#${SQL_SERVER_PORT}#g" ${DOVECOT_USERDB_CONF} ${DOVECOT_CONF_DIR}/*.conf

${CMD_SED} "s#\(.*user=vmail password=\).*#\1${VMAIL_DB_PASSWORD}#g" ${DOVECOT_USERDB_CONF}
${CMD_SED} "s#\(.*user=vmailadmin password=\).*#\1${VMAIL_DB_ADMIN_PASSWORD}#g" ${DOVECOT_USERDB_CONF} ${DOVECOT_CONF_DIR}/*.conf
