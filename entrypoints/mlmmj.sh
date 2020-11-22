#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

. /docker/entrypoints/functions.sh

MLMMJ_SPOOL_DIR="/var/vmail/mlmmj"
MLMMJ_ARCHIVE_DIR="/var/vmail/mlmmj-archive"

for d in ${MLMMJ_SPOOL_DIR} ${MLMMJ_ARCHIVE_DIR}; do
    [[ -d ${d} ]] || mkdir -p ${d}
done

touch_files ${SYS_USER_MLMMJ} ${SYS_GROUP_MLMMJ} 0550 /usr/bin/mlmmj-amime-receive

# Always set correct owner/group and permission of the data directories.
chown ${SYS_USER_MLMMJ}:${SYS_GROUP_MLMMJ} ${MLMMJ_SPOOL_DIR} ${MLMMJ_ARCHIVE_DIR}
