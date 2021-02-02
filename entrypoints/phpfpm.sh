#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

. /docker/entrypoints/functions.sh

install -d -o ${SYS_USER_SYSLOG} -g ${SYS_GROUP_SYSLOG} -m 0755 /var/log/php-fpm
install -d -o ${SYS_USER_NGINX} -g ${SYS_GROUP_NGINX} -m 0755 /run/php
