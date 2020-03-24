#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

. /docker/entrypoints/functions.sh

if [[ X"${FAIL2BAN_STORE_BANNED_IP_IN_DB}" == X'YES' ]]; then
    require_non_empty_var FAIL2BAN_DB_PASSWORD ${FAIL2BAN_DB_PASSWORD}
fi

fail2ban_dir_jail_conf_available="/etc/fail2ban/jail-available"
fail2ban_dir_jail_conf_enabled="/etc/fail2ban/jail.d"

# Enable jails.
enabled_jails="dovecot.local postfix.local postfix-pregreet.local sshd.local"
for i in ${enabled_jails}; do
    enable_fail2ban_jail ${i}
done

if [[ -f "/var/log/nginx/error.log" ]]; then
    enable_fail2ban_jail nginx-http-auth.local
fi

if [[ X"${USE_ROUNDCUBE}" == X'YES' ]]; then
    enable_fail2ban_jail roundcube.local
fi

# Create log directory and file.
create_log_dir /var/log/fail2ban
create_log_file /var/log/fail2ban/fail2ban.log
