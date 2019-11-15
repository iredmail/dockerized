#!/bin/sh

CLAMAV_USER='clamav'
CLAMAV_GROUP='clamav'
CLAMAV_DB_DIR='/var/lib/clamav'

CLAMD_CONF='/etc/clamav/clamd.conf'
FRESHCLAM_CONF='/etc/clamav/freshclam.conf'

# Check database directory
[[ ! -d ${CLAMAV_DB_DIR} ]] || mkdir -p ${CLAMAV_DB_DIR}

# Always set correct user/group and permission.
chown -R ${CLAMAV_USER}:${CLAMAV_GROUP} ${CLAMAV_DB_DIR}

# If DB files exist, start the clamav daemon.
_ready_to_start=YES

for f in bytecode.cvd daily.cvd main.cvd; do
    if [[ ! -f ${CLAMAV_DB_DIR}/${f} ]]; then
        _ready_to_start=NO
    fi
done

if [[ X"${_ready_to_start}" == X'NO' ]]; then
    echo "Running freshclam..."
    freshclam --user=${CLAMAV_USER}
fi

echo "Create /run/clamav/."
install -d -o clamav -g clamav -m 0755 /run/clamav/

echo "Run freshclam in background."
freshclam --checks=1 --daemon --user=${CLAMAV_USER} --config-file=${FRESHCLAM_CONF}

if [[ X"${_ready_to_start}" == X'YES' ]]; then
    echo "Starting clamd..."
    clamd --config-file=/etc/clamav/clamd.conf --foreground
fi

echo "Exit."
