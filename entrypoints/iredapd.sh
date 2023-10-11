#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

. /docker/entrypoints/functions.sh

IREDAPD_CONF="/opt/iredapd/settings.py"
IREDAPD_CUSTOM_CONF_DIR="/opt/iredmail/custom/iredapd"
IREDAPD_CUSTOM_CONF="/opt/iredmail/custom/iredapd/settings.py"
IREDAPD_LOG_DIR="/var/log/iredapd"
IREDAPD_LOG_FILE="/var/log/iredapd/iredapd.log"

require_non_empty_var IREDAPD_DB_PASSWORD ${IREDAPD_DB_PASSWORD}

[[ -d ${IREDAPD_CUSTOM_CONF_DIR} ]] || mkdir -p ${IREDAPD_CUSTOM_CONF_DIR}
[[ -f ${IREDAPD_CUSTOM_CONF} ]] || touch ${IREDAPD_CUSTOM_CONF}

create_log_dir ${IREDAPD_LOG_DIR}
create_log_file ${IREDAPD_LOG_FILE}

ln -sf ${IREDAPD_CUSTOM_CONF} /opt/iRedAPD-5.3/custom_settings.py

# Update placeholders in config file.
${CMD_SED} "s#PH_HOSTNAME#${HOSTNAME}#g" ${IREDAPD_CONF}
${CMD_SED} "s#PH_SQL_SERVER_ADDRESS#${SQL_SERVER_ADDRESS}#g" ${IREDAPD_CONF}
${CMD_SED} "s#PH_SQL_SERVER_PORT#${SQL_SERVER_PORT}#g" ${IREDAPD_CONF}

update_iredapd_setting vmail_db_password ${VMAIL_DB_PASSWORD}
update_iredapd_setting amavisd_db_password ${AMAVISD_DB_PASSWORD}
update_iredapd_setting iredapd_db_password ${IREDAPD_DB_PASSWORD}

if [[ X"${IREDAPD_SRS_SECRET}" != X'' ]]; then
    update_iredapd_setting iredapd_srs_secret ${IREDAPD_SRS_SECRET}
fi
