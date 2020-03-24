#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

. /docker/entrypoints/functions.sh

USERDB_CONF_DIR="/etc/postfix/mysql"
MAIN_CF="/etc/postfix/main.cf"
MASTER_CF="/etc/postfix/master.cf"
CUSTOM_CONF_DIR="/opt/iredmail/custom/postfix"
CUSTOM_DISCLAIMER_DIR="/opt/iredmail/custom/postfix/disclaimer"

DHPARAM512_FILE='/opt/iredmail/ssl/dhparam512.pem'
DHPARAM2048_FILE='/opt/iredmail/ssl/dhparam2048.pem'

if [[ X"${USE_IREDAPD}" == X'NO' ]]; then
    LOG "Disable iRedAPD."
    ${CMD_SED} 's#check_policy_service inet:127.0.0.1:7777##' ${MAIN_CF}
fi

if [[ X"${USE_IREDAPD}" == X'NO' ]] || [[ X"${POSTFIX_ENABLE_SRS}" == X'NO' ]]; then
    LOG "Disable SRS."
    ${CMD_SED} 's#tcp:127.0.0.1:7778##g' ${MAIN_CF}
    ${CMD_SED} 's#tcp:127.0.0.1:7779##g' ${MAIN_CF}
fi

if [[ X"${USE_ANTISPAM}" == X'NO' ]]; then
    LOG "Disable antispam."
    ${CMD_SED} 's#smtp-amavis:[127.0.0.1]:10024##g' ${MAIN_CF}
    ${CMD_SED} 's#    -o content_filter=smtp-amavis:[127.0.0.1]:10026##g' ${MASTER_CF}
fi

install -d -o root -g root -m 0555 ${CUSTOM_CONF_DIR}
install -d -o root -g root -m 0555 ${CUSTOM_DISCLAIMER_DIR}

# Create default disclaimer files.
touch ${CUSTOM_DISCLAIMER_DIR}/default.{txt,html}

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

install -d -o postfix -g root -m 0700 /var/spool/postfix/etc
for f in localtime hosts resolv.conf; do
    if [[ -f /etc/${f} ]]; then
        cp -f /etc/${f} /var/spool/postfix/etc/
        chown postfix:root /var/spool/postfix/etc/${f}
        chmod 0755 /var/spool/postfix/etc/${f}
    fi
done

if [[ ! -f ${DHPARAM512_FILE} ]]; then
    openssl dhparam -out ${DHPARAM512_FILE} 512 >/dev/null
fi
if [[ ! -f ${DHPARAM2048_FILE} ]]; then
    LOG "Generating dh param file: ${SSL_DHPARAM2048_FILE}. It make take a long time."
    openssl dhparam -out ${DHPARAM2048_FILE} 2048 >/dev/null
fi
chmod 0644 ${DHPARAM512_FILE} ${DHPARAM2048_FILE}

# Make sure log file exists.
create_log_file ${postfix_log_file}
# Create symbol link of mail log file.
ln -sf ${postfix_log_file} /var/log/maillog

# Update parameters.
${CMD_SED} "s#PH_HOSTNAME#${HOSTNAME}#g" ${MAIN_CF}

${CMD_SED} "s#PH_SQL_SERVER_ADDRESS#${SQL_SERVER_ADDRESS}#g" ${USERDB_CONF_DIR}/*.cf
${CMD_SED} "s#PH_SQL_SERVER_PORT#${SQL_SERVER_PORT}#g" ${USERDB_CONF_DIR}/*.cf
${CMD_SED} "s#PH_VMAIL_DB_PASSWORD#${VMAIL_DB_PASSWORD}#g" ${USERDB_CONF_DIR}/*.cf
