#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

. /docker/entrypoints/functions.sh

SOGO_CONF="/etc/sogo/sogo.conf"
SOGO_CONF_DIR="/etc/sogo"

DB_NAME="sogo"
DB_USER="sogo"

_size="$((MESSAGE_SIZE_LIMIT_IN_MB * 1024))"
${CMD_SED} "s#\(.*WOMaxUploadSize.*\)=.*#\1 = ${_size};#g" ${SOGO_CONF}
${CMD_SED} "s#\(.*SOGoMaximumMessageSizeLimit.*\)=.*#\1 = ${_size};#g" ${SOGO_CONF}

###################SOGo SQL ALWAYS UPDATE###################
${CMD_SED} "s#\(.*SOGoProfileURL.*\)=.*#\1 = \"mysql://${DB_USER}:${SOGO_DB_PASSWORD}@127.0.0.1:3306/${DB_NAME}/sogo_user_profile\";#g" ${SOGO_CONF}
${CMD_SED} "s#\(.*OCSFolderInfoURL.*\)=.*#\1 = \"mysql://${DB_USER}:${SOGO_DB_PASSWORD}@127.0.0.1:3306/${DB_NAME}/sogo_folder_info\";#g" ${SOGO_CONF}
${CMD_SED} "s#\(.*OCSSessionsFolderURL.*\)=.*#\1 = \"mysql://${DB_USER}:${SOGO_DB_PASSWORD}@127.0.0.1:3306/${DB_NAME}/sogo_sessions_folder\";#g" ${SOGO_CONF}
${CMD_SED} "s#\(.*OCSEMailAlarmsFolderURL.*\)=.*#\1 = \"mysql://${DB_USER}:${SOGO_DB_PASSWORD}@127.0.0.1:3306/${DB_NAME}/sogo_alarms_folder\";#g" ${SOGO_CONF}

### With 3 parameters below, SOGo requires only 9 SQL tables in total
### instead of creating 4 SQL tables for each user.
${CMD_SED} "s#\(.*OCSCacheFolderURL.*\)=.*#\1 = \"mysql://${DB_USER}:${SOGO_DB_PASSWORD}@127.0.0.1:3306/${DB_NAME}/sogo_cache_folder\";#g" ${SOGO_CONF}
${CMD_SED} "s#\(.*OCSStoreURL.*\)=.*#\1 = \"mysql://${DB_USER}:${SOGO_DB_PASSWORD}@127.0.0.1:3306/${DB_NAME}/sogo_store\";#g" ${SOGO_CONF}
${CMD_SED} "s#\(.*OCSAclURL.*\)=.*#\1 = \"mysql://${DB_USER}:${SOGO_DB_PASSWORD}@127.0.0.1:3306/${DB_NAME}/sogo_acl\";#g" ${SOGO_CONF}

### // Authentication using SQL
###    SOGoUserSources
${CMD_SED} "s#viewURL.*users.*#viewURL = \"mysql://${DB_USER}:${SOGO_DB_PASSWORD}@127.0.0.1:3306/${DB_NAME}/users\";#g" ${SOGO_CONF}
############################################################


################## SOGo PERMISSION PROBLEM ##################
chown ${SYS_USER_SOGO}:${SYS_GROUP_SOGO} -R ${SOGO_CONF_DIR}
chmod 0755 -R ${SOGO_CONF_DIR}
#############################################################

###################### SOGo External NGINX #######################
_internal_sogo_dir="/usr/lib/GNUstep/SOGo"
_external_sogo_dir="/usr/lib/GNUstep/SOGo_nginx"
if [[ X"${USE_NGINX}" == X'NO' ]]; then
    [[ -d ${_external_sogo_dir} ]] || mkdir -p ${_external_sogo_dir}

    cp -Rp ${_internal_sogo_dir}/. ${_external_sogo_dir}
fi
##################################################################

