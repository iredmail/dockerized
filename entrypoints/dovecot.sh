#!/usr/bin/env sh
# Author: Zhang Huangbin <zhb@iredmail.org>

# TODO Read below 2 values from Docker env.
HOSTNAME='docker-dev.iredmail.org'
POSTMASTER_EMAIL='postmaster@a.io'

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
GLOBAL_SIEVE_FILE="/var/vmail/sieve/dovecot.sieve"

# Custom config files.
CUSTOM_CONF_DIR="/opt/iredmail/custom/dovecot"
CUSTOM_ENABLED_CONF_DIR="/opt/iredmail/custom/dovecot/conf-enabled"
CUSTOM_GLOBAL_SIEVE_FILE="/opt/iredmail/custom/dovecot/dovecot.sieve"

# Create directory used to store ssl cert.
[[ -d ${SSL_CERT_DIR} ]] || mkdir -p ${SSL_CERT_DIR}

# Create self-signed ssl cert.
if [[ ! -f ${SSL_CERT_FILE} ]] || [[ ! -f ${SSL_KEY_FILE} ]]; then
    echo "* Generating self-signed ssl cert under ${SSL_CERT_DIR}, it may take a long time."
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
    echo "* Generating dh param file: ${SSL_DHPARAM2048_FILE}."
    openssl dhparam -out ${SSL_DHPARAM2048_FILE} 2048 >/dev/null
fi
chmod 0644 ${SSL_DHPARAM2048_FILE}

echo "* Create directory used to store custom config files."
[[ -d ${CUSTOM_CONF_DIR} ]] || mkdir -p ${CUSTOM_CONF_DIR}
[[ -d ${CUSTOM_ENABLED_CONF_DIR} ]] || mkdir -p ${CUSTOM_ENABLED_CONF_DIR}

echo "* Make sure custom config files exist."
touch ${CUSTOM_GLOBAL_SIEVE_FILE}

echo "* Running Dovecot..."
dovecot -c ${CONF} -F
