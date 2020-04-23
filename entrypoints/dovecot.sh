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

CONF="/etc/dovecot/dovecot.conf"
USERDB_CONF="/etc/dovecot/dovecot-mysql.conf"
CONF_DIR="/etc/dovecot"
AVAILABLE_CONF_DIR="/etc/dovecot/conf-available"
ENABLED_CONF_DIR="/etc/dovecot/conf-enabled"
GLOBAL_SIEVE_FILE="/var/vmail/sieve/dovecot.sieve"

# Custom config files.
CUSTOM_CONF_DIR="/opt/iredmail/custom/dovecot"
CUSTOM_ENABLED_CONF_DIR="/opt/iredmail/custom/dovecot/conf-enabled"
CUSTOM_GLOBAL_SIEVE_FILE="/opt/iredmail/custom/dovecot/dovecot.sieve"

# Create required directories
for d in ${MAILBOXES_DIR} \
    ${SSL_CERT_DIR} \
    ${CUSTOM_CONF_DIR} \
    ${CUSTOM_ENABLED_CONF_DIR} \
    ${ENABLED_CONF_DIR}; do
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

    cat ${SSL_CERT_FILE} ${SSL_KEY_FILE} > ${SSL_COMBINED_FILE}
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
    ln -s ${AVAILABLE_CONF_DIR}/${f} ${ENABLED_CONF_DIR}/${f}
done

touch ${CUSTOM_GLOBAL_SIEVE_FILE}

touch /etc/dovecot/dovecot-master-users /opt/iredmail/custom/dovecot/master-users
chown ${SYS_USER_DOVECOT}:${SYS_GROUP_DOVECOT} /etc/dovecot/dovecot-master-users /opt/iredmail/custom/dovecot/master-users
chmod 0400 /etc/dovecot/dovecot-master-users /opt/iredmail/custom/dovecot/master-users

# Set proper owner/group and permissions.
chown -R ${SYS_USER_VMAIL}:${SYS_GROUP_VMAIL} /usr/local/bin/scan_reported_mails /usr/local/bin/imapsieve
chmod 0550 /usr/local/bin/scan_reported_mails /usr/local/bin/imapsieve/*

# Update parameters.
${CMD_SED} "s#PH_HOSTNAME#${HOSTNAME}#g" /usr/local/bin/scan_reported_mails /usr/local/bin/imapsieve/imapsieve_copy /usr/local/bin/imapsieve/quota_warning.sh

${CMD_SED} "s#PH_SQL_SERVER_ADDRESS#${SQL_SERVER_ADDRESS}#g" ${USERDB_CONF} ${CONF_DIR}/*.conf
${CMD_SED} "s#PH_SQL_SERVER_PORT#${SQL_SERVER_PORT}#g" ${USERDB_CONF} ${CONF_DIR}/*.conf
${CMD_SED} "s#PH_VMAIL_DB_PASSWORD#${VMAIL_DB_PASSWORD}#g" ${USERDB_CONF}
${CMD_SED} "s#PH_VMAIL_DB_ADMIN_PASSWORD#${VMAIL_DB_ADMIN_PASSWORD}#g" ${USERDB_CONF} ${CONF_DIR}/*.conf

#LOG "Running Dovecot..."
#if [[ X"$1" == X'--background' ]]; then
#    shift 1
#    dovecot -c ${CONF}
#else
#    dovecot -c ${CONF} -F
#fi
