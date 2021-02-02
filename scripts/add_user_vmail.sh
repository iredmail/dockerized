#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

groupadd --gid 2000 vmail
useradd \
    --uid 2000 \
    --gid vmail \
    --shell /sbin/nologin \
    vmail
