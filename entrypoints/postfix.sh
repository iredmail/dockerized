#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

. /docker/entrypoints/functions.sh

POSTFIX_USERDB_LOOKUP_CONF_DIR="/etc/postfix/mysql"
POSTFIX_CONF_MAIN_CF="/etc/postfix/main.cf"
POSTFIX_CONF_MASTER_CF="/etc/postfix/master.cf"
POSTFIX_SPOOL_DIR="/var/spool/postfix"
POSTFIX_CUSTOM_CONF_DIR="/opt/iredmail/custom/postfix"
POSTFIX_CUSTOM_CONF_MAIN_CF="/opt/iredmail/custom/postfix/main.cf"
POSTFIX_CUSTOM_CONF_MASTER_CF="/opt/iredmail/custom/postfix/master.cf"
POSTFIX_CUSTOM_DISCLAIMER_DIR="/opt/iredmail/custom/postfix/disclaimer"

POSTFIX_LOG_FILE="/var/log/mail.log"

SSL_DHPARAM512_FILE='/opt/iredmail/ssl/dhparam512.pem'
SSL_DHPARAM2048_FILE='/opt/iredmail/ssl/dhparam2048.pem'

# Update message size limit.
_size="$((MESSAGE_SIZE_LIMIT_IN_MB * 1024 * 1024))"
${CMD_SED} "s#^mailbox_size_limit.*#mailbox_size_limit = ${_size}#g" ${POSTFIX_CONF_MAIN_CF}
${CMD_SED} "s#^message_size_limit.*#message_size_limit = ${_size}#g" ${POSTFIX_CONF_MAIN_CF}

if [[ X"${USE_IREDAPD}" == X'NO' ]]; then
    LOG "Disable iRedAPD."
    ${CMD_SED} 's#check_policy_service inet:127.0.0.1:7777##' ${POSTFIX_CONF_MAIN_CF}
fi

if [[ X"${USE_IREDAPD}" == X'NO' ]] || [[ X"${POSTFIX_ENABLE_SRS}" == X'NO' ]]; then
    LOG "Disable SRS."
    ${CMD_SED} 's#tcp:127.0.0.1:7778##g' ${POSTFIX_CONF_MAIN_CF}
    ${CMD_SED} 's#tcp:127.0.0.1:7779##g' ${POSTFIX_CONF_MAIN_CF}
fi

if [[ X"${USE_ANTISPAM}" != X'YES' ]]; then
    LOG "Disable antispam."
    ${CMD_SED} 's#smtp-amavis:\[127.0.0.1\]:10024##g' ${POSTFIX_CONF_MAIN_CF}
    ${CMD_SED} 's#    -o content_filter=smtp-amavis:\[127.0.0.1\]:10026##g' ${POSTFIX_CONF_MASTER_CF}
fi

chown ${SYS_USER_ROOT}:${SYS_GROUP_POSTFIX} ${POSTFIX_USERDB_LOOKUP_CONF_DIR}/*.cf

install -d -o ${SYS_USER_ROOT} -g ${SYS_GROUP_ROOT} -m 0755 ${POSTFIX_CUSTOM_CONF_DIR}
install -d -o ${SYS_USER_ROOT} -g ${SYS_GROUP_ROOT} -m 0755 ${POSTFIX_CUSTOM_DISCLAIMER_DIR}

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
    chown ${SYS_USER_ROOT}:${SYS_GROUP_POSTFIX} ${f}
    chmod 0640 ${f}
done

# Update /etc/postfix/aliases
for u in ${SYS_USER_AMAVISD} \
    ${SYS_USER_CLAMAV} \
    ${SYS_USER_DOVECOT} \
    ${SYS_USER_IREDADMIN} \
    ${SYS_USER_IREDAPD} \
    ${SYS_USER_MEMCACHED} \
    ${SYS_USER_MLMMJ} \
    ${SYS_USER_MYSQL} \
    ${SYS_USER_NETDATA} \
    ${SYS_USER_NGINX} \
    ${SYS_USER_POSTFIX} \
    ${SYS_USER_SOGO} \
    ${SYS_USER_SYSLOG} \
    ${SYS_USER_BIND} \
    openldap postgres prosody \
    ${SYS_USER_VMAIL}; do
    if ! grep "^${u}:" /etc/postfix/aliases &>/dev/null; then
        echo "${u}: root" >> /etc/postfix/aliases
    fi
done

${CMD_SED} 's#^root:.*##g' /etc/postfix/aliases
echo "${SYS_USER_ROOT}: ${POSTMASTER_EMAIL}" >> /etc/postfix/aliases
postalias /etc/postfix/aliases
postalias /opt/iredmail/custom/postfix/aliases

for f in /etc/postfix/transport \
    /etc/postfix/smtp_tls_policy \
    /opt/iredmail/custom/postfix/transport \
    /opt/iredmail/custom/postfix/smtp_tls_policy \
    /opt/iredmail/custom/postfix/sender_bcc \
    /opt/iredmail/custom/postfix/recipient_bcc; do
    postmap hash:${f}

    chown ${SYS_USER_ROOT}:${SYS_GROUP_POSTFIX} ${f}.db
    chmod 0640 ${f}.db
done

install -d -o ${SYS_USER_ROOT} -g ${SYS_GROUP_POSTFIX} -m 0770 ${POSTFIX_SPOOL_DIR}/etc
for f in localtime hosts resolv.conf; do
    if [[ -f /etc/${f} ]]; then
        cp -f /etc/${f} ${POSTFIX_SPOOL_DIR}/etc/
        chown ${SYS_USER_POSTFIX}:${SYS_GROUP_ROOT} ${POSTFIX_SPOOL_DIR}/etc/${f}
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

# Don't log to multiple files.
${CMD_PERL} 's/^(.*mail\.info)/#$1/g' /etc/rsyslog.d/50-default.conf
${CMD_PERL} 's/^(.*mail\.warn)/#$1/g' /etc/rsyslog.d/50-default.conf
${CMD_PERL} 's/^(.*mail\.err)/#$1/g' /etc/rsyslog.d/50-default.conf

# Update parameters.
${CMD_SED} "s#PH_HOSTNAME#${HOSTNAME}#g" ${POSTFIX_CONF_MAIN_CF}

${CMD_SED} "s#PH_SQL_SERVER_ADDRESS#${SQL_SERVER_ADDRESS}#g" ${POSTFIX_USERDB_LOOKUP_CONF_DIR}/*.cf
${CMD_SED} "s#PH_SQL_SERVER_PORT#${SQL_SERVER_PORT}#g" ${POSTFIX_USERDB_LOOKUP_CONF_DIR}/*.cf
${CMD_SED} "s#PH_VMAIL_DB_PASSWORD#${VMAIL_DB_PASSWORD}#g" ${POSTFIX_USERDB_LOOKUP_CONF_DIR}/*.cf

# Use custom main.cf/master.cf
if [ -f ${POSTFIX_CUSTOM_CONF_MAIN_CF} ]; then
    LOG "Found and use custom config file: ${POSTFIX_CUSTOM_CONF_MAIN_CF}."
    mv ${POSTFIX_CONF_MAIN_CF}{,.bak}
    ln -sf ${POSTFIX_CUSTOM_CONF_MAIN_CF} ${POSTFIX_CONF_MAIN_CF}
fi

if [ -f ${POSTFIX_CUSTOM_CONF_MASTER_CF} ]; then
    LOG "Found and use custom config file: ${POSTFIX_CUSTOM_CONF_MASTER_CF}."
    mv ${POSTFIX_CONF_MASTER_CF}{,.bak}
    ln -sf ${POSTFIX_CUSTOM_CONF_MASTER_CF} ${POSTFIX_CONF_MASTER_CF}
fi
