#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

. /docker/entrypoints/functions.sh

install -d -o ${SYS_USER_SYSLOG} -g ${SYS_GROUP_SYSLOG} -m 0755 /var/log/php-fpm
install -d -o ${SYS_USER_NGINX} -g ${SYS_GROUP_NGINX} -m 0755 /run/php


#################### phpfpm External NGINX ####################
_roundcube_phpfpm="/etc/php/8.1/fpm/pool.d/www.conf"

_phpfpm_listen_cmd="listen = 0.0.0.0:9001"
_phpfpm_resource_limit_cmd="security.limit_extensions =	"

if [[ X"${USE_NGINX}" == X'NO' ]]; then
    ${CMD_SED} "s#listen =.*#${_phpfpm_listen_cmd}#g" ${_roundcube_phpfpm}

    ${CMD_SED} "s#security.limit_extensions =.*#${_phpfpm_resource_limit_cmd}#g" ${_roundcube_phpfpm}
fi
###############################################################