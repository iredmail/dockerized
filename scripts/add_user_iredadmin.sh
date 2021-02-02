#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

groupadd --gid 2001 iredadmin
useradd \
    --uid 2001 \
    --gid iredadmin \
    --shell /sbin/nologin \
    iredadmin
