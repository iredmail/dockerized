#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

. /docker/entrypoints/functions.sh

CONF="/etc/amavisd.conf"
SPOOL_DIR="/var/spool/amavisd"
TEMP_DIR="/var/spool/amavisd/tmp"
QUARANTINE_DIR="/var/spool/amavisd/quarantine"
DB_DIR="/var/spool/amavisd/db"
VAR_DIR="/var/spool/amavisd/var"

DKIM_DIR="/opt/iredmail/custom/amavisd/dkim"
DKIM_KEY="${DKIM_DIR}/${FIRST_MAIL_DOMAIN}.pem"

CUSTOM_CONF_DIR="/opt/iredmail/custom/amavisd"

# ClamAV
CLAMAV_DB_DIR="/var/lib/clamav"

chown ${SYS_USER_ROOT}:${SYS_GROUP_AMAVISD} ${CONF}

for d in ${SPOOL_DIR} ${TEMP_DIR} ${QUARANTINE_DIR} ${DB_DIR} ${VAR_DIR}; do
    [[ -d ${d} ]] || install -d -o ${SYS_USER_AMAVISD} -g ${SYS_GROUP_AMAVISD} -m 0770 ${d}
done

[[ -d ${CUSTOM_CONF_DIR} ]] || install -d -o ${SYS_USER_ROOT} -g ${SYS_GROUP_ROOT} -m 0555 ${CUSTOM_CONF_DIR}

# Assign clamav daemon user to Amavisd group, so that it has permission to scan message.
addgroup ${SYS_USER_CLAMAV} ${SYS_GROUP_AMAVISD}

# Generate DKIM key for first mail domain.
install -d -o ${SYS_USER_AMAVISD} -g ${SYS_GROUP_AMAVISD} -m 0770 ${DKIM_DIR}
[[ -f ${DKIM_KEY} ]] || /usr/sbin/amavisd genrsa ${DKIM_KEY} 1024
chown ${SYS_USER_AMAVISD}:${SYS_GROUP_AMAVISD} ${DKIM_KEY}
chmod 0400 ${DKIM_KEY}

# ClamAV
install -d -o ${SYS_USER_CLAMAV} -g ${SYS_GROUP_CLAMAV} -m 0755 ${CLAMAV_DB_DIR}

# Update parameters.
${CMD_SED} "s#PH_HOSTNAME#${HOSTNAME}#g" ${CONF}
${CMD_SED} "s#PH_FIRST_MAIL_DOMAIN#${FIRST_MAIL_DOMAIN}#g" ${CONF}

${CMD_SED} "s#PH_SQL_SERVER_ADDRESS#${SQL_SERVER_ADDRESS}#g" ${CONF}
${CMD_SED} "s#PH_SQL_SERVER_PORT#${SQL_SERVER_PORT}#g" ${CONF}
${CMD_SED} "s#PH_AMAVISD_DB_PASSWORD#${AMAVISD_DB_PASSWORD}#g" ${CONF}

# Run `sa-update` if no rules yet.
LOG "Run 'sa-update' (required by Amavisd)."
sa-update -v

if [[ ! -f "${CLAMAV_DB_DIR}/main.cvd" ]] && [[ ! -f "${CLAMAV_DB_DIR}/bytecode.cvd" ]]; then
    LOG "Run 'freshclam' (required by ClamAV)."
    freshclam
fi
