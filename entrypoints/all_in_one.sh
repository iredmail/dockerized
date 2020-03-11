#!/bin/sh
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

ENTRYPOINTS_DIR="/docker/entrypoints"
. ${ENTRYPOINTS_DIR}/functions.sh

# Check reuired variables.
require_non_empty_var HOSTNAME ${HOSTNAME}
require_non_empty_var FIRST_MAIL_DOMAIN ${FIRST_MAIL_DOMAIN}
require_non_empty_var FIRST_MAIL_DOMAIN_ADMIN_PASSWORD ${FIRST_MAIL_DOMAIN_ADMIN_PASSWORD}

require_non_empty_var VMAIL_DB_PASSWORD ${VMAIL_DB_PASSWORD}
require_non_empty_var VMAIL_DB_ADMIN_PASSWORD ${VMAIL_DB_ADMIN_PASSWORD}

# Add required directories.
install -d -m 0755 /var/run/supervisord /var/log/supervisor

run_entrypoint ${ENTRYPOINTS_DIR}/mariadb.sh
run_entrypoint ${ENTRYPOINTS_DIR}/dovecot.sh
run_entrypoint ${ENTRYPOINTS_DIR}/postfix.sh
run_entrypoint ${ENTRYPOINTS_DIR}/mlmmj.sh
run_entrypoint ${ENTRYPOINTS_DIR}/mlmmjadmin.sh

# Applications controlled by supervisor.
# Program name must be the name of modular config files without '.conf'.
SUP_SERVICES="cron rsyslog mariadb dovecot postfix mlmmjadmin"

if [[ X"${USE_IREDAPD}" == X'YES' ]]; then
    run_entrypoint ${ENTRYPOINTS_DIR}/iredapd.sh
    SUP_SERVICES="${SUP_SERVICES} iredapd"
fi

if [[ X"${USE_ANTISPAM}" == X'YES' ]]; then
    run_entrypoint ${ENTRYPOINTS_DIR}/antispam.sh
    SUP_SERVICES="${SUP_SERVICES} clamav amavisd"
fi

# Nginx & php-fpm
if [[ X"${USE_ROUNDCUBE}" == X'YES' ]]; then
    run_entrypoint ${ENTRYPOINTS_DIR}/nginx.sh
    run_entrypoint ${ENTRYPOINTS_DIR}/phpfpm.sh
fi

if [[ X"${USE_ROUNDCUBE}" == X'YES' ]]; then
    run_entrypoint ${ENTRYPOINTS_DIR}/roundcube.sh
    SUP_SERVICES="${SUP_SERVICES} nginx phpfpm"
fi

for srv in ${SUP_SERVICES}; do
    ln -sf /etc/supervisor.d/conf-available/${srv}.conf /etc/supervisor.d/${srv}.conf
done

# Run specified commands in Dockerfile `CMD`.
LOG "CMD: $@"
exec "$@"
