#!/bin/sh

# Start all required services.
#   - mariadb
#   - dovecot
#   - iredapd (if enabled)
#   - postfix
#   - nginx
#   - php-fpm
#   - mlmmjadmin

ENTRYPOINTS_DIR="/docker/entrypoints"
. ${ENTRYPOINTS_DIR}/functions.sh

run_entrypoint ${ENTRYPOINTS_DIR}/mariadb.sh --background
run_entrypoint ${ENTRYPOINTS_DIR}/dovecot.sh --background
