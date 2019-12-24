#!/bin/sh

. /docker/entrypoints/functions.sh

CUSTOM_CONF_DIR="/opt/iredmail/custom/iredapd"
CUSTOM_CONF="/opt/iredmail/custom/iredapd/settings.py"

[[ -d ${CUSTOM_CONF_DIR} ]] || mkdir -p ${CUSTOM_CONF_DIR}
[[ -f ${CUSTOM_CONF} ]] || touch ${CUSTOM_CONF}

ln -sf ${CUSTOM_CONF} /opt/iRedAPD-3.3/custom_settings.py

${CMD_SED} "s#PH_HOSTNAME#${HOSTNAME}#g" /opt/iredapd/settings.py
