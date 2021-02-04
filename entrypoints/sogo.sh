#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

. /docker/entrypoints/functions.sh

SOGO_CONF="/etc/sogo/sogo.conf"

_size="$((MESSAGE_SIZE_LIMIT_IN_MB * 1024))"
${CMD_SED} "s#\(.*WOMaxUploadSize.*\)=.*#\1 = ${_size};#g" ${SOGO_CONF}
${CMD_SED} "s#\(.*SOGoMaximumMessageSizeLimit.*\)=.*#\1 = ${_size};#g" ${SOGO_CONF}

# Supervisor
install -d -m 0755 /var/run/supervisord /var/log/supervisor
SUP_SERVICES="cron rsyslog sogo"
#for srv in ${SUP_SERVICES}; do
#    ln -sf /etc/supervisor/${srv}.conf /etc/supervisor/conf.d/${srv}.conf
#done
