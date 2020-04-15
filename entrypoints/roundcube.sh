#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

. /docker/entrypoints/functions.sh

RC_DOCUMENTROOT="/opt/www/roundcubemail-1.4.3"
RC_DOCUMENTROOT_SYMLINK="/opt/www/roundcubemail"
RC_CONF="/opt/www/roundcubemail/config/config.inc.php"

CUSTOM_CONF_DIR="/opt/iredmail/custom/roundcube"
CUSTOM_CONF="/opt/iredmail/custom/roundcube/custom.inc.php"

DB_NAME="roundcubemail"
DB_USER="roundcube"

require_non_empty_var ROUNDCUBE_DB_PASSWORD ${ROUNDCUBE_DB_PASSWORD}
require_non_empty_var ROUNDCUBE_DES_KEY ${ROUNDCUBE_DES_KEY}

[[ -d ${CUSTOM_CONF_DIR} ]] || mkdir -p ${CUSTOM_CONF_DIR}

create_rc_custom_conf custom.inc.php
create_rc_custom_conf config_managesieve.inc.php
create_rc_custom_conf config_markasjunk.inc.php
create_rc_custom_conf config_password.inc.php

# Always set correct user/group and permission.
chown ${SYS_USER_NGINX}:${SYS_GROUP_NGINX} ${RC_CONF} ${CUSTOM_CONF} ${CUSTOM_CONF_DIR}/config_*.inc.php
chmod 0400 ${RC_CONF} ${CUSTOM_CONF} ${CUSTOM_CONF_DIR}/config_*.inc.php

# Update message size limit.
${CMD_SED} "s#\(.*max_message_size.*\)=.*#\1 = '${MESSAGE_SIZE_LIMIT_IN_MB}M';#g" ${RC_CONF}

# Create log directory and file.
create_log_dir /var/log/roundcube
create_log_file /var/log/roundcube/roundcube.log

# Enable modular Nginx config file for `/mail/` url.
gen_symlink_of_nginx_tmpl default-ssl roundcube 90-roundcube

# TODO Create symlinks for custom skins/plugins.
# TODO Setup cron jobs.
