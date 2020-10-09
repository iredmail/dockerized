#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

. /docker/entrypoints/functions.sh

IREDADMIN_WEB_ROOTDIR="/opt/www/iRedAdmin-beta"
IREDADMIN_WEB_ROOTDIR_SYMLINK="/opt/www/iredadmin"

IREDADMIN_LOG_DIR="/var/log/iredadmin"
IREDADMIN_LOG_FILE="/var/log/iredadmin/iredadmin.log"

CONF="/opt/www/iredadmin/settings.py"
CUSTOM_CONF_DIR="/opt/iredmail/custom/iredadmin"
CUSTOM_CONF="/opt/iredmail/custom/iredadmin/settings.py"
CUSTOM_CONF_SYMLINK="/opt/www/iredadmin/custom_settings.py"

require_non_empty_var IREDADMIN_DB_PASSWORD ${IREDADMIN_DB_PASSWORD}

[[ -L ${IREDADMIN_WEB_ROOTDIR_SYMLINK} ]] || ln -sf ${IREDADMIN_WEB_ROOTDIR} ${IREDADMIN_WEB_ROOTDIR_SYMLINK}
[[ -d ${CUSTOM_CONF_DIR} ]] || mkdir -p ${CUSTOM_CONF_DIR}
[[ -f ${CUSTOM_CONF} ]] || touch ${CUSTOM_CONF}

chown ${SYS_USER_IREDADMIN}:${SYS_GROUP_IREDADMIN} ${CONF} ${CUSTOM_CONF}
chmod 0400 ${CONF} ${CUSTOM_CONF}

ln -sf ${CUSTOM_CONF} ${IREDADMIN_WEB_ROOTDIR_SYMLINK}/custom_settings.py

create_log_dir ${IREDADMIN_LOG_DIR}
create_log_file ${IREDADMIN_LOG_FILE}

# Enable modular Nginx config file for `/mail/` url.
gen_symlink_of_nginx_tmpl default-ssl iredadmin 90-iredadmin

# Update parameters for initial run.
${CMD_SED} "s#PH_FIRST_MAIL_DOMAIN#${FIRST_MAIL_DOMAIN}#g" ${CONF}
${CMD_SED} "s#PH_HOSTNAME#${HOSTNAME}#g" ${CONF}
${CMD_SED} "s#PH_SQL_SERVER_ADDRESS#${SQL_SERVER_ADDRESS}#g" ${CONF}
${CMD_SED} "s#PH_SQL_SERVER_PORT#${SQL_SERVER_PORT}#g" ${CONF}

update_iredadmin_setting vmail_db_password ${VMAIL_DB_ADMIN_PASSWORD}
update_iredadmin_setting iredadmin_db_password ${IREDADMIN_DB_PASSWORD}
update_iredadmin_setting mlmmjadmin_api_token ${MLMMJADMIN_API_TOKEN}

if [[ X"${USE_ANTISPAM}" == X'YES' ]]; then
    update_iredadmin_setting amavisd_db_password ${AMAVISD_DB_PASSWORD}
else
    update_iredadmin_setting amavisd_enable_logging False bool
    update_iredadmin_setting amavisd_enable_quarantine False bool
    update_iredadmin_setting amavisd_enable_policy_lookup False bool
fi

if [[ X"${USE_IREDAPD}" == X'YES' ]]; then
    update_iredadmin_setting iredapd_enable_policy_lookup ${IREDAPD_DB_PASSWORD}
else
    update_iredadmin_setting iredapd_enabled False bool
fi

if [[ X"${FAIL2BAN_STORE_BANNED_IP_IN_DB}" == X'YES' ]]; then
    update_iredadmin_setting fail2ban_db_password ${FAIL2BAN_DB_PASSWORD}
else
    update_iredadmin_setting fail2ban_enabled False bool
fi
