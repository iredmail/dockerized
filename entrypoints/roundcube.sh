#!/bin/sh

CUSTOM_CONF_DIR="/opt/iredmail/custom/roundcube"
CUSTOM_CONF="/opt/iredmail/custom/roundcube/custom.inc.php"

[[ -d ${CUSTOM_CONF_DIR} ]] || mkdir -p ${CUSTOM_CONF_DIR}
[[ -f ${CUSTOM_CONF} ]] || touch ${CUSTOM_CONF}
