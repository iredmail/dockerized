#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

. /docker/entrypoints/functions.sh

CONF="/opt/iredapd/settings.py"
CUSTOM_CONF_DIR="/opt/iredmail/custom/iredapd"
CUSTOM_CONF="/opt/iredmail/custom/iredapd/settings.py"

require_non_empty_var IREDAPD_DB_PASSWORD ${IREDAPD_DB_PASSWORD}

[[ -d ${CUSTOM_CONF_DIR} ]] || mkdir -p ${CUSTOM_CONF_DIR}
[[ -f ${CUSTOM_CONF} ]] || touch ${CUSTOM_CONF}

ln -sf ${CUSTOM_CONF} /opt/iRedAPD-4.5/custom_settings.py

# Update placeholders in config file.
${CMD_SED} "s#PH_HOSTNAME#${HOSTNAME}#g" ${CONF}
${CMD_SED} "s#PH_SQL_SERVER_ADDRESS#${SQL_SERVER_ADDRESS}#g" ${CONF}
${CMD_SED} "s#PH_SQL_SERVER_PORT#${SQL_SERVER_PORT}#g" ${CONF}

update_iredapd_setting vmail_db_password ${VMAIL_DB_PASSWORD}
update_iredapd_setting amavisd_db_password ${AMAVISD_DB_PASSWORD}
update_iredapd_setting iredapd_db_password ${IREDAPD_DB_PASSWORD}

if [[ X"${IREDAPD_SRS_SECRET}" != X'' ]]; then
    update_iredapd_setting iredapd_srs_secret ${IREDAPD_SRS_SECRET}
fi
