#!/bin/sh

SED="sed -i '' -e"
echo "* Running syslogd."
/sbin/syslogd

echo "* Modify postfix config files based on Docker env variables."
echo "USE_IREDAPD=${USE_IREDAPD}"
echo "USE_ANTISPAM=${USE_ANTISPAM}"
echo "POSTFIX_ENABLE_SRS=${POSTFIX_ENABLE_SRS}"

if [[ X"${USE_IREDAPD}" == X'NO' ]]; then
    echo "- Disable iRedAPD."
    ${SED} 's#check_policy_service inet:127.0.0.1:7777##' /etc/postfix/main.cf
fi

if [[ X"${USE_IREDAPD}" == X'NO' ]] || [[ X"${POSTFIX_ENABLE_SRS}" == X'NO' ]]; then
    echo "- Disable SRS."
    ${SED} 's#tcp:127.0.0.1:7778##g' /etc/postfix/main.cf
    ${SED} 's#tcp:127.0.0.1:7779##g' /etc/postfix/main.cf
fi

if [[ X"${USE_ANTISPAM}" == X'NO' ]]; then
    echo "- Disable antispam."
    ${SED} 's#smtp-amavis:[127.0.0.1]:10024##g' /etc/postfix/main.cf
fi

echo "* Running postfix."
/usr/sbin/postfix start || exit 255

echo "* tail -f /var/log/messages"
tail -f /var/log/messages
