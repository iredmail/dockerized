#!/bin/sh

# Start all required services.
#   - mariadb
#   - dovecot
#   - iredapd (if enabled)
#   - postfix
#   - nginx
#   - php-fpm
#   - mlmmjadmin

ENTRYPOINTS_DIR="/docker/entrypoints"
. ${ENTRYPOINTS_DIR}/functions.sh

# Add required directories.
install -d -m 0755 /var/run/supervisord /var/log/supervisor

run_entrypoint ${ENTRYPOINTS_DIR}/mariadb.sh --background
run_entrypoint ${ENTRYPOINTS_DIR}/dovecot.sh --background

# Applications controlled by supervisor.
# Program name must be the name of modular config files without '.conf'.
#PROGRAMS="cron rsyslog mariadb mlmmjadmin dovecot clamav amavisd postfix"
PROGRAMS="cron rsyslog mariadb dovecot amavisd postfix"

[[ "${USE_ANTISPAM}" == "YES" ]] && PROGRAMS="${PROGRAMS} clamav amavisd"
[[ "${USE_IREDAPD}" == "YES" ]] && PROGRAMS="${PROGRAMS} iredapd"

for prog in ${PROGRAMS}; do
    ln -sf /etc/supervisor.d/conf-available/${prog}.conf /etc/supervisor.d/${prog}.conf
done

# Run specified commands in Dockerfile `CMD`.
exec "$@"
