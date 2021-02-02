#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

groupadd --gid 2003 mlmmj
useradd \
    --uid 2003 \
    --gid mlmmj \
    --shell /sbin/nologin \
    mlmmj
