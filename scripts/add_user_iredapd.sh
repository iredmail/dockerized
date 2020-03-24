#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

addgroup -g 2002 iredapd
adduser -D -H -u 2002 -G iredapd -s /sbin/nologin iredapd
