#!/bin/sh

CONF_AVAILABLE_DIR="/etc/nginx/conf-available"
CONF_ENABLED_DIR="/etc/nginx/conf-enabled"
SITES_AVAILABLE_DIR="/etc/nginx/sites-available"
SITES_ENABLED_DIR="/etc/nginx/sites-enabled"

sites="00-default.conf 00-default-ssl.conf"
[[ X"${USE_AUTOCONFIG}" == X'YES' ]] && sites="${sites} autoconfig.conf"

for site in ${sites}; do
    ln -sf ${SITES_AVAILABLE_DIR}/${site} ${SITES_ENABLED_DIR}/${site}
done

for conf in $(ls ${CONF_AVAILABLE_DIR}/*.conf); do
    f="$(basename ${conf})"
    ln -sf ${CONF_AVAILABLE_DIR}/${f} ${CONF_ENABLED_DIR}/${f}
done

[[ X"${USE_IREDADMIN}" == X'YES' ]] || rm -f ${CONF_ENABLED_DIR}/iredadmin.conf
