#!/bin/sh

. /docker/entrypoints/functions.sh

LOG "Running syslogd."
/sbin/syslogd

LOG "Modify postfix config files based on Docker env variables."
if [[ X"${USE_IREDAPD}" == X'NO' ]]; then
    LOG "  - Disable iRedAPD."
    ${CMD_SED} 's#check_policy_service inet:127.0.0.1:7777##' /etc/postfix/main.cf
fi

if [[ X"${USE_IREDAPD}" == X'NO' ]] || [[ X"${POSTFIX_ENABLE_SRS}" == X'NO' ]]; then
    LOG "  - Disable SRS."
    ${CMD_SED} 's#tcp:127.0.0.1:7778##g' /etc/postfix/main.cf
    ${CMD_SED} 's#tcp:127.0.0.1:7779##g' /etc/postfix/main.cf
fi

if [[ X"${USE_ANTISPAM}" == X'NO' ]]; then
    LOG "  - Disable antispam."
    ${CMD_SED} 's#smtp-amavis:[127.0.0.1]:10024##g' /etc/postfix/main.cf
    ${CMD_SED} 's#    -o content_filter=smtp-amavis:[127.0.0.1]:10026##g' /etc/postfix/master.cf
fi

LOG "Running postfix."
/usr/sbin/postfix start || exit 255

LOG "tail -f /var/log/messages"
tail -f /var/log/messages
