#!/bin/sh

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

# Applications controlled by supervisor.
# Program name must be the name of modular config files without '.conf'.
PROGRAMS="cron rsyslog mariadb dovecot postfix"

if [[ X"${USE_IREDAPD}" == X'YES' ]]; then
    run_entrypoint ${ENTRYPOINTS_DIR}/iredapd.sh
    PROGRAMS="${PROGRAMS} iredapd"
fi

if [[ X"${USE_ANTISPAM}" == X'YES' ]]; then
    run_entrypoint ${ENTRYPOINTS_DIR}/antispam.sh
    PROGRAMS="${PROGRAMS} clamav amavisd"
fi

# Nginx & php-fpm
if [[ X"${USE_ROUNDCUBE}" == X'YES' ]]; then
    run_entrypoint ${ENTRYPOINTS_DIR}/nginx.sh
    run_entrypoint ${ENTRYPOINTS_DIR}/phpfpm.sh
fi

if [[ X"${USE_ROUNDCUBE}" == X'YES' ]]; then
    run_entrypoint ${ENTRYPOINTS_DIR}/roundcube.sh
    PROGRAMS="${PROGRAMS} nginx phpfpm"
fi

for prog in ${PROGRAMS}; do
    ln -sf /etc/supervisor.d/conf-available/${prog}.conf /etc/supervisor.d/${prog}.conf
done

# Run specified commands in Dockerfile `CMD`.
LOG "CMD: $@"
exec "$@"
