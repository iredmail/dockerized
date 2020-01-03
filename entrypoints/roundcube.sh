#!/bin/sh

RC_DOCUMENTROOT="/opt/www/roundcubemail-1.4.2"
RC_DOCUMENTROOT_SYMLINK="/opt/www/roundcubemail"
RC_CONF="/opt/www/roundcubemail/config/config.inc.php"

CUSTOM_CONF_DIR="/opt/iredmail/custom/roundcube"
CUSTOM_CONF="/opt/iredmail/custom/roundcube/custom.inc.php"

DB_NAME="roundcubemail"
DB_USER="roundcube"

. /docker/entrypoints/functions.sh
require_non_empty_var ROUNDCUBE_DB_PASSWORD ${ROUNDCUBE_DB_PASSWORD}
require_non_empty_var ROUNDCUBE_DES_KEY ${ROUNDCUBE_DES_KEY}

[[ -d ${CUSTOM_CONF_DIR} ]] || mkdir -p ${CUSTOM_CONF_DIR}
[[ -f ${CUSTOM_CONF} ]] || touch ${CUSTOM_CONF}

chown nginx:nginx ${RC_CONF}
chmod 0400 ${RC_CONF}

# Enable required PHP modules.
# mcrypt
# intl

# TODO Create symlinks for custom skins/plugins.
# TODO Setup cron jobs.
