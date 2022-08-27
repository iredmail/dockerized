#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

. /docker/entrypoints/functions.sh

CLAMAV_DB_DIR='/var/lib/clamav'
CLAMD_CONF='/etc/clamav/clamd.conf'
FRESHCLAM_CONF='/etc/clamav/freshclam.conf'
CLAMAV_USER='clamav'

# Check database directory
[[ ! -d ${CLAMAV_DB_DIR} ]] || mkdir -p ${CLAMAV_DB_DIR}

# Always set correct user/group and permission.
chown -R ${SYS_USER_CLAMAV}:${SYS_GROUP_CLAMAV} ${CLAMAV_DB_DIR}

# iRedMail generates logrotate config file for clamav, so we remove the default
# files to avoid duplicate.
rm -f /etc/logrotate.d/clamav-daemon
rm -f /etc/logrotate.d/clamav-freshclam

# If DB files exist, start the clamav daemon.
_ready_to_start=YES

for f in bytecode.cvd main.cvd; do
    if [[ ! -f ${CLAMAV_DB_DIR}/${f} ]]; then
        _ready_to_start=NO
    fi
done

# Use either daily.cld or daily.cvd
if [[ ! -f ${CLAMAV_DB_DIR}/daily.cvd ]] && [[ ! -f ${CLAMAV_DB_DIR}/daily.cld ]]; then
    _ready_to_start=NO
fi

if [[ X"${_ready_to_start}" == X'NO' ]]; then
    echo "* Running freshclam..."
    freshclam --user=${CLAMAV_USER}
fi

echo "* Create /run/clamav/."
install -d -o clamav -g clamav -m 0755 /run/clamav/

echo "* Run freshclam in background."
freshclam --checks=1 --daemon --user=${CLAMAV_USER} --config-file=${FRESHCLAM_CONF}
