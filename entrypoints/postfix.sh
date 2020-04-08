#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

. /docker/entrypoints/functions.sh

POSTFIX_USERDB_LOOKUP_CONF_DIR="/etc/postfix/mysql"
POSTFIX_CONF_MAIN_CF="/etc/postfix/main.cf"
POSTFIX_CONF_MASTER_CF="/etc/postfix/master.cf"
POSTFIX_SPOOL_DIR="/var/spool/postfix"
POSTFIX_CUSTOM_CONF_DIR="/opt/iredmail/custom/postfix"
POSTFIX_CUSTOM_DISCLAIMER_DIR="/opt/iredmail/custom/postfix/disclaimer"

POSTFIX_LOG_FILE="/var/log/mail.log"

SSL_DHPARAM512_FILE='/opt/iredmail/ssl/dhparam512.pem'
SSL_DHPARAM2048_FILE='/opt/iredmail/ssl/dhparam2048.pem'

if [[ X"${USE_IREDAPD}" == X'NO' ]]; then
    LOG "Disable iRedAPD."
    ${CMD_SED} 's#check_policy_service inet:127.0.0.1:7777##' ${POSTFIX_CONF_MAIN_CF}
fi

if [[ X"${USE_IREDAPD}" == X'NO' ]] || [[ X"${POSTFIX_ENABLE_SRS}" == X'NO' ]]; then
    LOG "Disable SRS."
    ${CMD_SED} 's#tcp:127.0.0.1:7778##g' ${POSTFIX_CONF_MAIN_CF}
    ${CMD_SED} 's#tcp:127.0.0.1:7779##g' ${POSTFIX_CONF_MAIN_CF}
fi

if [[ X"${USE_ANTISPAM}" == X'NO' ]]; then
    LOG "Disable antispam."
    ${CMD_SED} 's#smtp-amavis:[127.0.0.1]:10024##g' ${POSTFIX_CONF_MAIN_CF}
    ${CMD_SED} 's#    -o content_filter=smtp-amavis:[127.0.0.1]:10026##g' ${POSTFIX_CONF_MASTER_CF}
fi

install -d -o root -g root -m 0555 ${POSTFIX_CUSTOM_CONF_DIR}
install -d -o root -g root -m 0555 ${POSTFIX_CUSTOM_DISCLAIMER_DIR}

# Create default disclaimer files.
touch ${POSTFIX_CUSTOM_DISCLAIMER_DIR}/default.txt
touch ${POSTFIX_CUSTOM_DISCLAIMER_DIR}/default.html

# Make sure custom config files exist with correct owner/group and permission.
for f in /opt/iredmail/custom/postfix/aliases \
    /opt/iredmail/custom/postfix/helo_access.pcre \
    /opt/iredmail/custom/postfix/rdns_access.pcre \
    /opt/iredmail/custom/postfix/postscreen_access.cidr \
    /opt/iredmail/custom/postfix/header_checks.pcre \
    /opt/iredmail/custom/postfix/body_checks.pcre \
    /opt/iredmail/custom/postfix/smtp_tls_policy \
    /opt/iredmail/custom/postfix/transport \
    /opt/iredmail/custom/postfix/sender_access.pcre \
    /opt/iredmail/custom/postfix/sender_bcc \
    /opt/iredmail/custom/postfix/recipient_bcc; do
    touch ${f}
    chown root:postfix ${f}
    chmod 0640 ${f}
done

# Update /etc/postfix/aliases
for u in amavis \
    named \
    clamav \
    dovecot \
    iredadmin \
    iredapd \
    memcached \
    mlmmj \
    mysql \
    netdata \
    nginx \
    ldap \
    postgres \
    postfix \
    prosody \
    sogo \
    root \
    vmail; do
    if ! grep "^${u}:" /etc/postfix/aliases &>/dev/null; then
        echo "${u}: root" >> /etc/postfix/aliases
    fi
done
${CMD_SED} 's#^root:.*##g' /etc/postfix/aliases
echo "root: ${POSTMASTER_EMAIL}" >> /etc/postfix/aliases
postalias /etc/postfix/aliases
postalias /opt/iredmail/custom/postfix/aliases

for f in /etc/postfix/transport \
    /etc/postfix/smtp_tls_policy \
    /opt/iredmail/custom/postfix/transport \
    /opt/iredmail/custom/postfix/smtp_tls_policy \
    /opt/iredmail/custom/postfix/sender_bcc \
    /opt/iredmail/custom/postfix/recipient_bcc; do
    postmap hash:${f}

    chown root:postfix ${f}.db
    chmod 0640 ${f}.db
done

install -d -o postfix -g root -m 0700 ${POSTFIX_SPOOL_DIR}/etc
for f in localtime hosts resolv.conf; do
    if [[ -f /etc/${f} ]]; then
        cp -f /etc/${f} ${POSTFIX_SPOOL_DIR}/etc/
        chown postfix:root ${POSTFIX_SPOOL_DIR}/etc/${f}
        chmod 0755 ${POSTFIX_SPOOL_DIR}/etc/${f}
    fi
done

if [[ ! -f ${SSL_DHPARAM512_FILE} ]]; then
    openssl dhparam -out ${SSL_DHPARAM512_FILE} 512 >/dev/null
fi
if [[ ! -f ${SSL_DHPARAM2048_FILE} ]]; then
    LOG "Generating dh param file: ${SSL_SSL_DHPARAM2048_FILE}. It make take a long time."
    openssl dhparam -out ${SSL_DHPARAM2048_FILE} 2048 >/dev/null
fi
chmod 0644 ${SSL_DHPARAM512_FILE} ${SSL_DHPARAM2048_FILE}

# Make sure log file exists.
create_log_file ${POSTFIX_LOG_FILE}

if [ X"${POSTFIX_LOG_FILE}" != X'/var/log/maillog' ]; then
    # Create symbol link of mail log file.
    ln -sf ${POSTFIX_LOG_FILE} /var/log/maillog
fi

# Update parameters.
${CMD_SED} "s#PH_HOSTNAME#${HOSTNAME}#g" ${POSTFIX_CONF_MAIN_CF}

${CMD_SED} "s#PH_SQL_SERVER_ADDRESS#${SQL_SERVER_ADDRESS}#g" ${POSTFIX_USERDB_LOOKUP_CONF_DIR}/*.cf
${CMD_SED} "s#PH_SQL_SERVER_PORT#${SQL_SERVER_PORT}#g" ${POSTFIX_USERDB_LOOKUP_CONF_DIR}/*.cf
${CMD_SED} "s#PH_VMAIL_DB_PASSWORD#${VMAIL_DB_PASSWORD}#g" ${POSTFIX_USERDB_LOOKUP_CONF_DIR}/*.cf
