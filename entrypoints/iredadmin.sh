#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

. /docker/entrypoints/functions.sh

IREDADMIN_WEB_ROOTDIR="/opt/www/iRedAdmin-1.0"
IREDADMIN_WEB_ROOTDIR_SYMLINK="/opt/www/iredadmin"

SYS_USER_IREDADMIN="iredadmin"
SYS_GROUP_IREDADMIN="iredadmin"

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

# Enable modular Nginx config file for `/mail/` url.
gen_symlink_of_nginx_tmpl default-ssl iredadmin 90-iredadmin

# Update placeholders in config file.
${CMD_SED} "s#PH_FIRST_MAIL_DOMAIN#${FIRST_MAIL_DOMAIN}#g" ${CONF}
${CMD_SED} "s#PH_HOSTNAME#${HOSTNAME}#g" ${CONF}
${CMD_SED} "s#PH_SQL_SERVER_ADDRESS#${SQL_SERVER_ADDRESS}#g" ${CONF}
${CMD_SED} "s#PH_SQL_SERVER_PORT#${SQL_SERVER_PORT}#g" ${CONF}

${CMD_SED} "s#PH_VMAIL_DB_ADMIN_PASSWORD#${VMAIL_DB_ADMIN_PASSWORD}#g" ${CONF}
${CMD_SED} "s#PH_IREDADMIN_DB_PASSWORD#${IREDADMIN_DB_PASSWORD}#g" ${CONF}
${CMD_SED} "s#PH_MLMMJADMIN_API_TOKEN#${MLMMJADMIN_API_TOKEN}#g" ${CONF}

if [[ X"${USE_ANTISPAM}" == X'YES' ]]; then
    ${CMD_SED} "s#PH_AMAVISD_DB_PASSWORD#${AMAVISD_DB_PASSWORD}#g" ${CONF}
else
    ${CMD_SED} "s#^amavisd_enable_logging = True#amavisd_enable_logging = False#g" ${CONF}
    ${CMD_SED} "s#^amavisd_enable_quarantine = True#amavisd_enable_quarantine = False#g" ${CONF}
    ${CMD_SED} "s#^amavisd_enable_policy_lookup = True#amavisd_enable_policy_lookup = False#g" ${CONF}
fi

if [[ X"${USE_IREDAPD}" == X'YES' ]]; then
    ${CMD_SED} "s#PH_IREDAPD_DB_PASSWORD#${IREDAPD_DB_PASSWORD}#g" ${CONF}
else
    ${CMD_SED} "s#^iredapd_enabled = True#iredapd_enabled = False#g" ${CONF}
fi

if [[ X"${FAIL2BAN_STORE_BANNED_IP_IN_DB}" == X'YES' ]]; then
    ${CMD_SED} "s#PH_FAIL2BAN_DB_PASSWORD#${FAIL2BAN_DB_PASSWORD}#g" ${CONF}
else
    ${CMD_SED} "s#^fail2ban_enabled = True#fail2ban_enabled = False#g" ${CONF}
fi
