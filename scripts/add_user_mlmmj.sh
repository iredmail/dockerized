#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

addgroup -g 2003 mlmmj
adduser -D -H -u 2003 -G mlmmj -s /sbin/nologin mlmmj
