#!/bin/sh

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

addgroup -g 2000 vmail
adduser -D -H -u 2000 -G vmail -s /sbin/nologin vmail
