#!/bin/sh

. /docker/entrypoints/functions.sh

CONF="/opt/iredapd/settings.py"
CUSTOM_CONF_DIR="/opt/iredmail/custom/iredapd"
CUSTOM_CONF="/opt/iredmail/custom/iredapd/settings.py"

[[ -d ${CUSTOM_CONF_DIR} ]] || mkdir -p ${CUSTOM_CONF_DIR}
[[ -f ${CUSTOM_CONF} ]] || touch ${CUSTOM_CONF}

ln -sf ${CUSTOM_CONF} /opt/iRedAPD-3.3/custom_settings.py

${CMD_SED} "s#PH_HOSTNAME#${HOSTNAME}#g" ${CONF}

${CMD_SED} "s#PH_SQL_SERVER_ADDRESS#${SQL_SERVER_ADDRESS}#g" ${CONF}
${CMD_SED} "s#PH_SQL_SERVER_PORT#${SQL_SERVER_PORT}#g" ${CONF}

${CMD_SED} "s#PH_AMAVISD_DB_PASSWORD#${AMAVISD_DB_PASSWORD}#g" ${CONF}

# Apply patch for iRedAPD-3.3 to run in foreground.
cd /opt/iredapd/ && patch -p1 < /patches/iredapd-3.3-foreground.patch >/dev/null
