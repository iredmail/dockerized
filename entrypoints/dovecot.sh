#!/usr/bin/env sh
# Author: Zhang Huangbin <zhb@iredmail.org>

POSTMASTER_EMAIL="${POSTMASTER_EMAIL:=postmaster@${FIRST_MAIL_DOMAIN}}"

# SSL cert.
SSL_CERT_DIR='/opt/iredmail/ssl'
SSL_CERT_FILE='/opt/iredmail/ssl/cert.pem'
SSL_KEY_FILE='/opt/iredmail/ssl/key.pem'
SSL_COMBINED_FILE='/opt/iredmail/ssl/combined.pem'
SSL_KEY_LENGTH='2048'
SSL_CERT_COUNTRY='SI'
SSL_CERT_STATE='Domzale'
SSL_CERT_CITY='Domzale'
SSL_CERT_DEPARTMENT='IT'
SSL_DHPARAM2048_FILE='/opt/iredmail/ssl/dhparam2048.pem'

CONF="/etc/dovecot/dovecot.conf"
USERDB_CONF="/etc/dovecot/dovecot-mysql.conf"
CONF_DIR="/etc/dovecot"
GLOBAL_SIEVE_FILE="/var/vmail/sieve/dovecot.sieve"

# Custom config files.
CUSTOM_CONF_DIR="/opt/iredmail/custom/dovecot"
CUSTOM_ENABLED_CONF_DIR="/opt/iredmail/custom/dovecot/conf-enabled"
CUSTOM_GLOBAL_SIEVE_FILE="/opt/iredmail/custom/dovecot/dovecot.sieve"

. /docker/entrypoints/functions.sh

# Create directory used to store ssl cert.
[[ -d ${SSL_CERT_DIR} ]] || mkdir -p ${SSL_CERT_DIR}

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

[[ -d ${STORAGE_MAILBOXES_DIR} ]] || mkdir -p ${STORAGE_MAILBOXES_DIR}
# If directory contains many mailboxes, `chown/chmod -R` will take a long time.
chown vmail:vmail ${STORAGE_MAILBOXES_DIR}
chmod 0700 ${STORAGE_MAILBOXES_DIR}

[[ -d ${CUSTOM_CONF_DIR} ]] || mkdir -p ${CUSTOM_CONF_DIR}
[[ -d ${CUSTOM_ENABLED_CONF_DIR} ]] || mkdir -p ${CUSTOM_ENABLED_CONF_DIR}

LOG "Make sure custom sieve file exist."
touch ${CUSTOM_GLOBAL_SIEVE_FILE}

touch /etc/dovecot/dovecot-master-users
chown dovecot:dovecot /etc/dovecot/dovecot-master-users
chmod 0400 /etc/dovecot/dovecot-master-users

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
