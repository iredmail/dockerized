#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

ENTRYPOINTS_DIR="/docker/entrypoints"
DEFAULT_SETTINGS_CONF="${ENTRYPOINTS_DIR}/default_settings.conf"

# Custom config file on Docker host, not in container.
CUSTOM_SETTINGS_CONF="/etc/iredmail-docker.conf"

. ${ENTRYPOINTS_DIR}/functions.sh

# Store env in a temporary file for further reading.
tmp_env_file='/tmp/env'
env > ${tmp_env_file}

. ${DEFAULT_SETTINGS_CONF}

params="$(grep '^[0-9a-zA-Z]' ${DEFAULT_SETTINGS_CONF} | awk -F'=' '{print $1}')"

# Set random passwords.
if [ X"${MYSQL_USE_RANDOM_PASSWORDS}" == X'YES' ]; then
    for param in ${params}; do
        if echo ${param} | grep -E '(_DB_PASSWORD|^MYSQL_ROOT_PASSWORD|^VMAIL_DB_ADMIN_PASSWORD)$' &>/dev/null; then
            echo "${param}=$(${RANDOM_PASSWORD})" >> ${DEFAULT_SETTINGS_CONF}
        fi
    done
fi

# If parameters are defined as environment variables, append them to config
# file.
for param in ${params}; do
    # Use '..*' to match non-empty value.
    _env_line="$(grep "^${param}=" ${tmp_env_file})"
    _env_value="${_env_line#*=}"

    if [ X"${_env_value}" != X'' ]; then
        echo ${_env_line} >> ${DEFAULT_SETTINGS_CONF}
    fi
done

# It now contains both default and custom settings.
. ${DEFAULT_SETTINGS_CONF}

# Check reuired variables.
require_non_empty_var HOSTNAME ${HOSTNAME}
require_non_empty_var FIRST_MAIL_DOMAIN ${FIRST_MAIL_DOMAIN}
require_non_empty_var FIRST_MAIL_DOMAIN_ADMIN_PASSWORD ${FIRST_MAIL_DOMAIN_ADMIN_PASSWORD}

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

if [[ X"${USE_FAIL2BAN}" == X'YES' ]]; then
    run_entrypoint ${ENTRYPOINTS_DIR}/fail2ban.sh
    SUP_SERVICES="${SUP_SERVICES} fail2ban"
fi

for srv in ${SUP_SERVICES}; do
    ln -sf /etc/supervisor.d/conf-available/${srv}.conf /etc/supervisor.d/${srv}.conf
done

# Run specified commands in Dockerfile `CMD`.
LOG "CMD: $@"
exec "$@"
