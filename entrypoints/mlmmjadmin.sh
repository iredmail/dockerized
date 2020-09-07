#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

. /docker/entrypoints/functions.sh

CONF="/opt/mlmmjadmin/settings.py"
CUSTOM_CONF_DIR="/opt/iredmail/custom/mlmmjadmin"
CUSTOM_CONF="/opt/iredmail/custom/mlmmjadmin/settings.py"

require_non_empty_var VMAIL_DB_ADMIN_PASSWORD ${VMAIL_DB_ADMIN_PASSWORD}

[[ -d ${CUSTOM_CONF_DIR} ]] || mkdir -p ${CUSTOM_CONF_DIR}
[[ -f ${CUSTOM_CONF} ]] || touch ${CUSTOM_CONF}

ln -sf ${CUSTOM_CONF} /opt/mlmmjadmin/custom_settings.py

# Update placeholders in config file.
${CMD_SED} "s#PH_SQL_SERVER_ADDRESS#${SQL_SERVER_ADDRESS}#g" ${CONF}
${CMD_SED} "s#PH_SQL_SERVER_PORT#${SQL_SERVER_PORT}#g" ${CONF}

update_mlmmjadmin_setting iredmail_sql_db_password ${VMAIL_DB_ADMIN_PASSWORD}
update_mlmmjadmin_setting api_auth_tokens ${MLMMJADMIN_API_TOKEN}
