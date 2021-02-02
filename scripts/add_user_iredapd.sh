#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

groupadd --gid 2002 iredapd
useradd \
    --uid 2002 \
    --gid iredapd \
    --shell /sbin/nologin \
    iredapd
