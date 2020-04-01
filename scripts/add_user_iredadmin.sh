#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

addgroup -g 2001 iredadmin
adduser -D -H -u 2001 -G iredadmin -s /sbin/nologin iredadmin
