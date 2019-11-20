#!/bin/sh

CUSTOM_CONF_DIR="/opt/iredmail/custom/iredapd"
CUSTOM_CONF="/opt/iredmail/custom/iredapd/settings.py"

[[ -d ${CUSTOM_CONF_DIR} ]] || mkdir -p ${CUSTOM_CONF_DIR}
[[ -f ${CUSTOM_CONF} ]] || touch ${CUSTOM_CONF}

ln -sf ${CUSTOM_CONF} /opt/iRedAPD-3.2/custom_settings.py

echo "* Running syslogd."
/sbin/syslogd

/usr/bin/python2 /opt/iredapd/iredapd.py

echo "* tail -f /var/log/messages"
tail -f /var/log/messages
