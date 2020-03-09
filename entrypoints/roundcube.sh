#!/bin/sh

RC_DOCUMENTROOT="/opt/www/roundcubemail-1.4.3"
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

create_rc_plugin_custom_conf() {
    # Usage: create_rc_plugin_custom_conf <plugin-name>
    _plugin="$1"
    _conf="${CUSTOM_CONF_DIR}/config_${_plugin}.inc.php"

    if [[ ! -f ${_conf} ]]; then
        touch ${_conf}
        echo '<?php' >> ${_conf}
    fi

    chown nginx:nginx ${_conf}
    chmod 0400 ${_conf}
}

chown nginx:nginx ${RC_CONF}
chmod 0400 ${RC_CONF}

create_rc_plugin_custom_conf password
create_rc_plugin_custom_conf managesieve
create_rc_plugin_custom_conf markasjunk

# Enable required PHP modules.
# mcrypt
# intl

# TODO Create symlinks for custom skins/plugins.
# TODO Setup cron jobs.
