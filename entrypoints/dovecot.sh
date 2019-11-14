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

# Create directory used to store ssl cert.
[[ -d ${SSL_CERT_DIR} ]] || mkdir -p ${SSL_CERT_DIR}

# Create self-signed ssl cert.
if [[ ! -f ${SSL_CERT_FILE} ]] || [[ ! -f ${SSL_KEY_FILE} ]]; then
    echo "Generating self-signed ssl cert under ${SSL_CERT_DIR}."
    openssl req -x509 -nodes -sha256 -days 3650 \
        -subj "/C=${SSL_CERT_COUNTRY}/ST=${SSL_CERT_STATE}/L=${SSL_CERT_CITY}/O=${SSL_CERT_DEPARTMENT}/CN=${HOSTNAME}/emailAddress=${POSTMASTER_EMAIL}" \
        -newkey rsa:${SSL_KEY_LENGTH} \
        -out ${SSL_CERT_FILE} \
        -keyout ${SSL_KEY_FILE}

    cat ${SSL_CERT_FILE} ${SSL_KEY_FILE} > ${SSL_COMBINED_FILE}
fi
chmod 0644 ${SSL_CERT_FILE} ${SSL_KEY_FILE} ${SSL_COMBINED_FILE}

# Create dh param.
if [[ ! -f ${SSL_DHPARAM2048_FILE} ]]; then
    openssl dhparam -out ${SSL_DHPARAM2048_FILE} 2048
fi
chmod 0644 ${SSL_DHPARAM2048_FILE}

# Create `vmail` group/user.
addgroup -g 2000 vmail && \
    adduser -D -H \
    -u 2000 \
    -G vmail \
    -s /sbin/nologin \
    vmail

# Run Dovecot.
dovecot -c /etc/dovecot/dovecot.conf -F
