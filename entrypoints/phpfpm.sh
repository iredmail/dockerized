#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

install -d -o root -g root -m 0755 /var/log/php-fpm
install -d -o nginx -g nginx -m 0755 /run/php-fpm
