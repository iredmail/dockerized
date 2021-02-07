#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

. /docker/entrypoints/functions.sh

# Disable imklog module.
${CMD_PERL} 's/(.*imklog.*)/#${1}/g' /etc/rsyslog.conf
